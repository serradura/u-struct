# frozen_string_literal: true

require 'test_helper'

class Micro::StructWithOptionalMembersTest < Minitest::Test
  Person0 = Micro::Struct.new(optional: [:first_name, :last_name])
  Person1 = Micro::Struct.new(required: :first_name, optional: :last_name)
  Person2 = Micro::Struct.with(:readonly).new(:first_name, optional: [:last_name])

  def test_the_constructor
    person0 = Person0.new

    assert_instance_of(Person0::Struct, person0)

    assert_nil(person0.first_name)
    assert_nil(person0.last_name)

    # --

    [ Person1, Person2 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo')

      assert_instance_of(mod::Struct, person)

      assert_equal('Rodrigo', person.first_name)
      assert_nil(person.last_name)
    end

    # --

    [ Person1, Person2 ].each do |mod|
      error = assert_raises(ArgumentError) { mod.new }

      assert_equal('missing keyword: first_name', error.message)
    end
  end

  def test_attributes_reading
    [ Person0, Person1, Person2 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_instance_of(mod::Struct, person)

      assert_equal('Rodrigo', person.first_name)
      assert_equal('Serradura', person.last_name)
    end
  end

  def test_the_struct_members
    [ Person0, Person1, Person2 ].each do |mod|
      assert_equal([:first_name, :last_name], mod.members)
    end
  end
end
