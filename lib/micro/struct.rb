# frozen_string_literal: true

require_relative 'struct/version'

module Micro
  # Micro::Struct.new(:first_name, :last_name, ...)
  #
  # Micro::Struct.with(:to_ary).new(:name) # or .with(:to_hash), .with(:to_proc)
  #
  # Micro::Struct.with(:to_ary, :to_hash).new(:name)
  #
  # Micro::Struct.with(:to_ary, :to_hash, :to_proc).new(:name)
  #
  # Micro::Struct.new(:name) {}
  #
  # Micro::Struct.with(...).new(:name) {}
  module Struct
    class Creator
      module Features
        DISABLED =
          { to_ary: false,
            to_hash: false,
            to_proc: false }.freeze

        Expose = ->(to_ary:, to_hash:, to_proc:) do
          { to_ary: to_ary,
            to_hash: to_hash,
            to_proc: to_proc }
        end

        def self.check(names)
          features_to_enable =
            Array(names).each_with_object({}) { |name, memo| memo[name] = true }

          Expose.(**DISABLED.merge(features_to_enable))
        end
      end

      def initialize(features)
        @features = Features.check(features)
      end

      def new(*members, &block)
        def_module do |mod|
          def_struct(mod, members, block) do |struct|
            def_initialize(mod, struct)
            def_to_ary(struct)
            def_to_hash(struct)
            def_to_proc(mod)
          end
        end
      end

      private

      def def_module(&block)
        Module.new.tap(&block)
      end

      def def_struct(mod, members, block)
        struct = ::Struct.new(*members, &block)
        struct.send(:private_class_method, :new)

        mod.const_set(:Struct, struct)

        yield struct
      end

      def def_initialize(mod, struct)
        # The .new() method will require all of the Struct's keyword arguments.
        # We are doing this because Struct's keyword_init option doesn't do that.
        mod.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)    #
          def self.new(#{struct.members.join(':, ')}:)      # def self.new(a:, b:) do
            Struct.send(:new, #{struct.members.join(', ')}) #   Struct.send(:new, a, b)
          end                                               # end

          def self.members
            Struct.members
          end
        RUBY
      end

      def def_to_ary(struct)
        struct.send(:alias_method, :to_ary, :to_a) if @features[:to_ary]
      end

      def def_to_hash(struct)
        struct.send(:alias_method, :to_hash, :to_h) if @features[:to_hash]
      end

      def def_to_proc(mod)
        return unless @features[:to_proc]

        mod.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
          def self.to_proc
            ->(hash) { new(**hash) }
          end
        RUBY
      end
    end

    def self.new(*members, &block)
      with.new(*members, &block)
    end

    def self.with(*features)
      Creator.new(features)
    end

    private_constant :Creator
  end
end
