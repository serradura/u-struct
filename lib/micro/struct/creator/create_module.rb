# frozen_string_literal: true

class Micro::Struct::Creator
  module CreateModule
    extend self

    def with(required_members, optional_members, features)
      container = Module.new

      def_initialize(container, required_members, optional_members)
      def_triple_eq(container)
      def_members(container)
      def_to_proc(container, features)

      container
    end

    private

      def def_initialize(container, required_members, optional_members)
        required = "#{required_members.join(':, ')}#{':' unless required_members.empty?}"
        optional = "#{optional_members.join(': nil, ')}#{': nil' unless optional_members.empty?}"

        method_arguments = [required, optional].reject(&:empty?).join(', ')
        struct_arguments = (required_members + optional_members).join(', ')

        # The .new() method will require all required keyword arguments.
        # We are doing this because the Struct constructor keyword init option treats everything as optional.
        #
        container.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def self.new(#{method_arguments})        # def self.new(a:, b:) do
          Struct.send(:new, #{struct_arguments}) #   Struct.send(:new, a, b)
        end                                      # end
        RUBY
      end

      def def_triple_eq(container)
        container.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def self.===(other)
          Struct === other
        end
        RUBY
      end

      def def_members(container)
        container.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def self.members
          Struct.members
        end
        RUBY
      end

      def def_to_proc(container, features)
        return unless features[:to_proc]

        container.module_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def self.to_proc
          ->(hash) { new(**hash) }
        end
        RUBY
      end
  end

  private_constant :CreateModule
end
