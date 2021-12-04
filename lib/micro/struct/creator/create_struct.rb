# frozen_string_literal: true

class Micro::Struct::Creator
  module CreateStruct
    extend self

    def with(required_members, optional_members, features, &block)
      struct = ::Struct.new(*(required_members + optional_members), &block)
      struct.send(:private_class_method, :new)

      def_to_ary(struct) if features[:to_ary]
      def_to_hash(struct) if features[:to_hash]
      def_readonly(struct) if features[:readonly]
      def_instance_copy(struct) if features[:readonly] || features[:instance_copy]

      struct
    end

    private

      def def_to_ary(struct)
        struct.send(:alias_method, :to_ary, :to_a)
      end

      def def_to_hash(struct)
        struct.send(:alias_method, :to_hash, :to_h)
      end

      def def_readonly(struct)
        struct.send(:private, *struct.members.map { |member| "#{member}=" })
      end

      def def_instance_copy(struct)
        struct.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          def with(**members)
            self.class.const_get(:Container, false).new(**to_h.merge(members))
          end
        RUBY
      end
  end

  private_constant :CreateStruct
end
