# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_InstanceMethod_Test < Minitest::Test
  def test_the_micro_struct_instance_method
    person = Micro::Struct.instance(first_name: 'Rodrigo', last_name: 'Serradura')

    assert_kind_of(::Struct, person)

    assert_equal('Rodrigo', person.first_name)
    assert_equal('Serradura', person.last_name)

    person.first_name = 'John'
    person.last_name = 'Doe'

    assert_equal('John', person.first_name)
    assert_equal('Doe', person.last_name)
  end

  def test_the_micro_struct_instance_method_with_any_feature
    person = Micro::Struct.with(:readonly).instance(first_name: 'Rodrigo', last_name: 'Serradura')

    assert_kind_of(::Struct, person)

    assert_equal('Rodrigo', person.first_name)
    assert_equal('Serradura', person.last_name)

    refute_respond_to(person, :first_name=)
    refute_respond_to(person, :last_name=)
    refute_respond_to(person, :[]=)
  end

  def test_the_micro_struct_instance_method_receiving_a_block
    person1 = Micro::Struct.instance(first_name: 'Rodrigo', last_name: 'Serradura') do
      def name
        "#{first_name} #{last_name}"
      end
    end

    person2 = Micro::Struct.with(:readonly).instance(first_name: 'Rodrigo', last_name: 'Serradura') do
      def name
        "#{first_name} #{last_name}"
      end
    end

    assert_kind_of(::Struct, person1)
    assert_kind_of(::Struct, person2)    

    assert_equal('Rodrigo Serradura', person1.name)
    assert_equal('Rodrigo Serradura', person2.name)

    assert_respond_to(person1, :first_name=)
    assert_respond_to(person1, :last_name=)
    assert_respond_to(person1, :[]=)

    refute_respond_to(person2, :first_name=)
    refute_respond_to(person2, :last_name=)
    refute_respond_to(person2, :[]=)
  end
end
