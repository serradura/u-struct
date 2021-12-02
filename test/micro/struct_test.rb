# frozen_string_literal: true

require "test_helper"

class Micro::StructTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Micro::Struct::VERSION
  end

  Person1 = Micro::Struct.new(:name)

  Person2 = Micro::Struct.new(:first_name, :last_name) do
    def name
      "#{first_name} #{last_name}"
    end
  end

  def test_missing_keyword_error
    error1 = assert_raises(ArgumentError) { Person1.new }

    assert_equal('missing keyword: name', error1.message)

    # --

    error2 = assert_raises(ArgumentError) { Person2.new }

    assert_equal('missing keywords: first_name, last_name', error2.message)
  end

  def test_that_a_module_is_created
    assert_instance_of(Module, Person1)

    assert_instance_of(Module, Person2)
  end

  def test_that_the_module_contains_a_struct
    assert(Person1::Struct < ::Struct)

    assert(Person2::Struct < ::Struct)
  end

  def test_the_struct_constructor_should_be_private
    error1 = assert_raises(NoMethodError) { Person1::Struct.new }

    assert_match(/private method `new' called for .*Person1::Struct/, error1.message)

    # --

    error2 = assert_raises(NoMethodError) { Person2::Struct.new }

    assert_match(/private method `new' called for .*Person2::Struct/, error2.message)
  end

  def test_the_micro_struct_instances
    person1 = Person1.new(name: 'Rodrigo Serradura')

    assert_instance_of(Person1::Struct, person1)

    assert_equal('Rodrigo Serradura', person1.name)

    # --

    person2 = Person2.new(first_name: 'Rodrigo', last_name: 'Serradura')

    assert_instance_of(Person2::Struct, person2)

    assert_equal('Rodrigo', person2.first_name)
    assert_equal('Serradura', person2.last_name)

    assert_equal('Rodrigo Serradura', person2.name)
  end

  def test_micro_struct_instances_created_from_to_proc
    person1 = [{name: 'Rodrigo Serradura'}].map(&Person1).first

    assert_instance_of(Person1::Struct, person1)

    assert_equal('Rodrigo Serradura', person1.name)

    # --

    person2 = [{first_name: 'Rodrigo', last_name: 'Serradura'}].map(&Person2).first

    assert_instance_of(Person2::Struct, person2)

    assert_equal('Rodrigo Serradura', person2.name)
  end

  def test_the_to_ary_method_of_micro_struct_instances
    person1 = Person1.new(name: 'Rodrigo Serradura')

    person_name, * = person1

    assert_equal('Rodrigo Serradura', person_name)

    [person1].each { |(name)| assert_equal('Rodrigo Serradura', name) }

    # --

    person2 = Person2.new(first_name: 'Rodrigo', last_name: 'Serradura')

    person_first_name, person_last_name = person2

    assert_equal('Rodrigo', person_first_name)
    assert_equal('Serradura', person_last_name)

    [person2].each do |(first_name, last_name)|
      assert_equal('Rodrigo', first_name)
      assert_equal('Serradura', last_name)
    end
  end

  ExposeHash = ->(**hash) { hash }

  def test_the_to_hash_method_of_micro_struct_instances
    person1 = Person1.new(name: 'Rodrigo Serradura')

    assert_equal({name: 'Rodrigo Serradura'}, ExposeHash.(**person1))

    # --

    person2 = Person2.new(first_name: 'Rodrigo', last_name: 'Serradura')

    assert_equal({first_name: 'Rodrigo', last_name: 'Serradura'}, ExposeHash.(**person2))
  end
end
