# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_Features_Readonly_Test < Minitest::Test
  Person1 = Micro::Struct.new(:first_name, :last_name)
  Person2 = Micro::Struct.with(:readonly).new(:first_name, :last_name)

  def test_attributes_reading
    [Person1, Person2].each do |struct|
      person = struct.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_instance_of(struct, person)

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

    assert_match(/private method `first_name=' called for .*Person2/, error1.message)

    error2 = assert_raises(NoMethodError) { person2.last_name = 'Foo' }

    assert_match(/private method `last_name=' called for .*Person2/, error2.message)

    error2 = assert_raises(NoMethodError) { person2[:last_name] = 'Foo' }

    assert_match(/private method `\[\]=' called for .*Person2/, error2.message)
  end

  def test_instance_copying
    [Person1, Person2].each do |struct|
      person = struct.new(first_name: 'Rodrigo', last_name: 'Serradura')

      error = assert_raises(NoMethodError) { person.with(last_name: 'Bar') }

      assert_match(/undefined method `with' for .*Person[12]/, error.message)
    end
  end
end
