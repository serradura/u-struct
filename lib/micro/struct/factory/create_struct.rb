# frozen_string_literal: true

module Micro::Struct
  class Factory
    module CreateStruct
      extend self

      def with(members, block, features)
        struct = ::Struct.new(*members.required_and_optional)

        ClassScope.def_new(struct, members)
      
        ClassScope.def_features(struct, features) if features.is_a?(Features::Exposed)
        ClassScope.def_to_proc(struct)            if features.option?(:to_proc)
        ClassScope.def_private_writers(struct)    if features.option?(:readonly)

        InstanceScope.def_with(struct)    if features.option?(:instance_copy)
        InstanceScope.def_to_ary(struct)  if features.option?(:to_ary)
        InstanceScope.def_to_hash(struct) if features.option?(:to_hash)

        ClassScope.evaluate(struct, block)

        struct
      end

      module ClassScope
        def self.def_new(struct, members)
          # The .new() method will require all required keyword arguments.
          # We are doing this because the Struct constructor keyword init option treats everything as optional.
          #
          struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            class << self
              undef_method :new

              def new(#{members.to_eval.keyword_args})                         # def new(a:, b:, c: nil) do
                instance = allocate                                            #   instance = allocate
                instance.send(:initialize, #{members.to_eval.positional_args}) #   instance.send(:initialize, a, b, c)
                instance                                                       #   instance
              end                                                              # end

              alias __new__ new
            end
          RUBY
        end

        def self.def_features(struct, features)
          struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            class << self
              attr_accessor :__features__

              alias features __features__
            end
          RUBY

          struct.__features__ = features

          struct.send(:private_class_method, :__features__=)
        end

        def self.def_to_proc(struct)
          struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def self.to_proc
              ->(hash) { new(**hash) }
            end
          RUBY
        end

        def self.def_private_writers(struct)
          struct.send(:private, :[]=)
          struct.send(:private, *struct.members.map { |member| "#{member}=" })
        end

        def self.evaluate(struct, block)
          struct.class_eval(&block) if block
        end
      end

      module InstanceScope
        def self.def_to_ary(struct)
          struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def to_ary
              to_a
            end
          RUBY
        end

        def self.def_to_hash(struct)
          struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def to_hash
              to_h
            end
          RUBY
        end

        def self.def_with(struct)
          struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            def with(**members)
              self.class.new(**to_h.merge(members))
            end
          RUBY
        end
      end
    end

    private_constant :CreateStruct
  end
end
