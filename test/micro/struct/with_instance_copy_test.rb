# frozen_string_literal: true

require 'test_helper'

class Micro::StructWithInstanceCopyTest < Minitest::Test
  Person = Micro::Struct.with(:instance_copy).new(:first_name, :last_name)

  def test_attributes_reading
    person = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')

    assert_instance_of(Person::Struct, person)

    assert_equal('Rodrigo', person.first_name)
    assert_equal('Serradura', person.last_name)
  end

  def test_attributes_writing
    person = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')

    assert_equal('Rodrigo', person.first_name)
    assert_equal('Serradura', person.last_name)

    person.first_name = 'Foo'
    person.last_name = 'Bar'

    assert_equal('Foo', person.first_name)
    assert_equal('Bar', person.last_name)
  end

  def test_instance_copying
    person_a = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')

    person_b = person_a.with(last_name: 'Foo')

    assert_equal('Rodrigo', person_a.first_name)
    assert_equal('Serradura', person_a.last_name)

    assert_equal('Rodrigo', person_b.first_name)
    assert_equal('Foo', person_b.last_name)

    refute_same(person_a, person_b)
  end
end
