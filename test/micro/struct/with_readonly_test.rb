# frozen_string_literal: true

require 'test_helper'

class Micro::StructWithReadonlyTest < Minitest::Test
  Person1 = Micro::Struct.new(:first_name, :last_name)
  Person2 = Micro::Struct.with(:readonly).new(:first_name, :last_name)

  def test_attributes_reading
    [ Person1, Person2 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_instance_of(mod::Struct, person)

      assert_equal('Rodrigo', person.first_name)
      assert_equal('Serradura', person.last_name)
    end
  end

  def test_attributes_writing
    person1 = Person1.new(first_name: 'Rodrigo', last_name: 'Serradura')

    assert_equal('Rodrigo', person1.first_name)
    assert_equal('Serradura', person1.last_name)

    person1.first_name = 'Foo'
    person1.last_name = 'Bar'

    assert_equal('Foo', person1.first_name)
    assert_equal('Bar', person1.last_name)

    # --

    person2 = Person2.new(first_name: 'Rodrigo', last_name: 'Serradura')

    error1 = assert_raises(NoMethodError) { person2.first_name = 'Bar' }

    assert_match(/private method `first_name=' called for .*Person2::Struct/, error1.message)

    error2 = assert_raises(NoMethodError) { person2.last_name = 'Foo' }

    assert_match(/private method `last_name=' called for .*Person2::Struct/, error2.message)
  end

  def test_instance_copying
    person1 = Person1.new(first_name: 'Rodrigo', last_name: 'Serradura')

    error = assert_raises(NoMethodError) { person1.with(last_name: 'Bar') }

    assert_match(/undefined method `with' for .*Person1::Struct/, error.message)

    # --

    person2a = Person2.new(first_name: 'Rodrigo', last_name: 'Serradura')

    person2b = person2a.with(last_name: 'Foo')

    assert_equal('Rodrigo', person2a.first_name)
    assert_equal('Serradura', person2a.last_name)

    assert_equal('Rodrigo', person2b.first_name)
    assert_equal('Foo', person2b.last_name)

    refute_same(person2a, person2b)
  end
end
