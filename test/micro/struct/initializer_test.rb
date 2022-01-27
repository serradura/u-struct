# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_Initializer_Test < Minitest::Test
  Person1 = Micro::Struct.new(:first_name, :last_name)

  Person2 = Micro::Struct.new(:f, :l) do
    def self.new(first_name:, last_name:)
      __new__(f: first_name, l: last_name)
    end

    alias first_name f
    alias last_name l
  end

  def test_the_new_constructor
    [Person2].each do |struct|
      person = struct.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_instance_of(struct, person)

      assert_equal('Rodrigo', person.first_name)
      assert_equal('Serradura', person.last_name)
    end
  end

  def test_the__new__constructor
    person1 = Person1.__new__(first_name: 'Rodrigo', last_name: 'Serradura')

    assert(Person1 === person1)
    assert_instance_of(Person1, person1)

    assert_equal('Rodrigo', person1.first_name)
    assert_equal('Serradura', person1.last_name)

    # --

    person2 = Person2.__new__(f: 'Rodrigo', l: 'Serradura')

    assert(Person2 === person2)
    assert_instance_of(Person2, person2)

    assert_equal('Rodrigo', person2.first_name)
    assert_equal('Serradura', person2.last_name)
  end
end
