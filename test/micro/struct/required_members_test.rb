# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_RequiredMembers_Test < Minitest::Test
  Person1 = Micro::Struct.new(:first_name, :last_name)
  Person2 = Micro::Struct.new(required: [:first_name, :last_name])

  def test_the_constructor
    [ Person1, Person2 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_instance_of(mod::Struct, person)

      assert_equal('Rodrigo', person.first_name)
      assert_equal('Serradura', person.last_name)
    end

    # --

    [ Person1, Person2 ].each do |mod|
      error = assert_raises(ArgumentError) { mod.new }

      assert_match(/missing keywords: :?first_name, :?last_name/, error.message)
    end
  end

  def test_attributes_reading
    [ Person1, Person2 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_instance_of(mod::Struct, person)

      assert_equal('Rodrigo', person.first_name)
      assert_equal('Serradura', person.last_name)
    end
  end

  def test_attributes_writing
    [ Person1, Person2 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_instance_of(mod::Struct, person)

      assert_equal('Rodrigo', person.first_name)

      person.first_name = 'Digo'

      assert_equal('Digo', person.first_name)
    end
  end

  def test_the_struct_members
    [ Person1, Person2 ].each do |mod|
      assert_equal([:first_name, :last_name], mod.members)
    end
  end

  def test_the_module_triple_equal
    [ Person1, Person2 ].each do |mod|
      person = mod.new(first_name: '', last_name: '')

      assert(mod === person)
      assert(mod::Struct === person)
    end
  end
end
