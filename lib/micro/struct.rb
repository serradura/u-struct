# frozen_string_literal: true

require_relative 'struct/version'

module Micro
  # Like in a regular Struct, you can define one or many attributes.
  #   Micro::Struct.new(:first_name, :last_name, ...)
  #
  # You can also pass a block to define custom methods.
  #   Micro::Struct.new(:name) {}
  #
  # Available features (use one, many or all):
  # .with(:to_ary, :to_hash, :to_proc, :readonly, :instance_copy)
  #
  #   Micro::Struct.with(:to_ary).new(:name)
  #   Micro::Struct.with(:to_ary, :to_hash).new(:name)
  #   Micro::Struct.with(:to_ary, :to_hash, :to_proc).new(:name)
  #
  #   Micro::Struct.with(...).new(...) {}
  module Struct
    class Creator
      module Features
        DISABLED =
          { to_ary: false,
            to_hash: false,
            to_proc: false,
            readonly: false,
            instance_copy: false
          }.freeze

        Expose = ->(to_ary:, to_hash:, to_proc:, readonly:, instance_copy:) do
          { to_ary: to_ary,
            to_hash: to_hash,
            to_proc: to_proc,
            readonly: readonly,
            instance_copy: instance_copy }
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
        def_container do |container|
          def_struct(container, members, block) do |struct|
            def_initialize(container, struct)

            def_to_ary(struct)
            def_to_hash(struct)
            def_readonly(struct)
            def_instance_copy(struct)
          end

          def_to_proc(container)
        end
      end

      private

      def def_container(&block)
        Module.new.tap(&block)
      end

      def def_struct(container, members, block)
        struct = ::Struct.new(*members, &block)
        struct.const_set(:Container, container)
        struct.send(:private_class_method, :new)

        container.const_set(:Struct, struct)

        yield struct
      end

      def def_initialize(container, struct)
        # The .new() method will require all of the Struct's keyword arguments.
        # We are doing this because Struct's keyword_init option doesn't do that.
        container.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)    #
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

      def def_readonly(struct)
        return unless @features[:readonly]

        struct.send(:private, *struct.members.map { |member| "#{member}=" })
      end

      def def_instance_copy(struct)
        return unless (@features[:readonly] || @features[:instance_copy])

        struct.class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
          def with(**members)
            self.class.const_get(:Container, false).new(**to_h.merge(members))
          end
        RUBY
      end

      def def_to_proc(container)
        return unless @features[:to_proc]

        container.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)
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
