# frozen_string_literal: true

class Micro::Struct::Factory
  module CreateStruct
    extend self

    def with(required_members, optional_members, features, &block)
      struct = ::Struct.new(*(required_members + optional_members))

      def_initialize(struct, required_members, optional_members)
      def_to_ary(struct) if features[:to_ary]
      def_to_hash(struct) if features[:to_hash]
      def_to_proc(struct) if features[:to_proc]
      def_readonly(struct) if features[:readonly]
      def_instance_copy(struct) if features[:instance_copy]

      struct.class_eval(&block) if block

      struct
    end

    private

      def def_initialize(struct, required_members, optional_members)
        required = "#{required_members.join(':, ')}#{':' unless required_members.empty?}"
        optional = "#{optional_members.join(': nil, ')}#{': nil' unless optional_members.empty?}"

        keywords_arguments = [required, optional].reject(&:empty?).join(', ')
        positional_arguments = (required_members + optional_members).join(', ')

        # The .new() method will require all required keyword arguments.
        # We are doing this because the Struct constructor keyword init option treats everything as optional.
        #
        struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          class << self
            undef_method :new

            def new(#{keywords_arguments})                        # def new(a:, b:, c: nil) do
              instance = allocate                                 #   instance = allocate
              instance.send(:initialize, #{positional_arguments}) #   instance.send(:initialize, a, b, c)
              instance                                            #   instance
            end                                                   # end

            alias __new__ new
          end
        RUBY
      end

      def def_to_ary(struct)
        struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def to_ary
            to_a
          end
        RUBY
      end

      def def_to_hash(struct)
        struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def to_hash
            to_h
          end
        RUBY
      end

      def def_readonly(struct)
        struct.send(:private, *struct.members.map { |member| "#{member}=" })
      end

      def def_instance_copy(struct)
        struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def with(**members)
            self.class.new(**to_h.merge(members))
          end
        RUBY
      end

      def def_to_proc(struct)
        struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def self.to_proc
            ->(hash) { new(**hash) }
          end
        RUBY
      end
  end

  private_constant :CreateStruct
end
