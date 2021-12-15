# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_Features_ToProc_ToAry_ToHash_Test < Minitest::Test
  With_ToAry = Micro::Struct.with(:to_ary)
  With_ToAry_ToHash = Micro::Struct.with(:to_ary, :to_hash)
  With_ToAry_ToProc = Micro::Struct.with(:to_ary, :to_proc)

  With_ToHash = Micro::Struct.with(:to_hash)
  With_ToHash_ToProc = Micro::Struct.with(:to_hash, :to_proc)

  With_ToProc = Micro::Struct.with(:to_proc)

  With_ToAry_ToHash_ToProc = Micro::Struct.with(:to_ary, :to_hash, :to_proc)

  Person0 = Micro::Struct.new(:name)

  Person1 = Micro::Struct.new(:first_name, :last_name)

  Person2a = With_ToAry.new(required: [:first_name, :last_name])
  Person2b = With_ToAry_ToHash.new(:first_name, required: :last_name)
  Person2c = With_ToAry_ToProc.new(:first_name, required: [:last_name])

  Person3a = With_ToHash.new(:first_name, :last_name)
  Person3b = Person2b # .with(:to_hash, :to_ary)
  Person3c = With_ToHash_ToProc.new(:first_name, :last_name)

  Person4a = With_ToProc.new(:first_name, :last_name)
  Person4b = Person2c # .with(:to_proc, :to_ary)
  Person4c = Person3c # .with(:to_proc, :to_hash)

  Person5 = With_ToAry_ToHash_ToProc.new(:first_name, :last_name)

  NAME_METHOD = proc do
    def name
      "#{first_name} #{last_name}"
    end
  end

  Person6a = With_ToAry.new(:first_name, :last_name, &NAME_METHOD)
  Person6b = With_ToAry_ToHash.new(:first_name, :last_name, &NAME_METHOD)
  Person6c = With_ToAry_ToProc.new(:first_name, :last_name, &NAME_METHOD)

  Person7a = With_ToHash.new(:first_name, :last_name, &NAME_METHOD)
  Person7b = Person6b # .with(:to_hash, :to_ary)
  Person7c = With_ToHash_ToProc.new(:first_name, :last_name, &NAME_METHOD)

  Person8a = With_ToProc.new(:first_name, :last_name, &NAME_METHOD)
  Person8b = Person6c # .with(:to_proc, :to_ary)
  Person8c = Person7c # .with(:to_proc, :to_hash)

  Person9 = With_ToAry_ToHash_ToProc.new(:first_name, :last_name, &NAME_METHOD)

  def test_missing_keyword_error
    error1 = assert_raises(ArgumentError) { Person0.new }

    assert_match(/missing keyword: :?name/, error1.message)

    # --

    [ Person1,
      Person2a, Person2b, Person2c,
      Person3a, Person3b, Person3c,
      Person4a, Person4b, Person4c,
      Person5,
      Person6a, Person6b, Person6c,
      Person7a, Person7b, Person7c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
      error = assert_raises(ArgumentError) { mod.new }

      assert_match(/missing keywords: :?first_name, :?last_name/, error.message)
    end
  end

  def test_that_a_module_is_created
    [ Person0, Person1,
      Person2a, Person2b, Person2c,
      Person3a, Person3b, Person3c,
      Person4a, Person4b, Person4c,
      Person5,
      Person6a, Person6b, Person6c,
      Person7a, Person7b, Person7c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
      assert_instance_of(Module, mod, mod.inspect)
    end
  end

  def test_the_module_members
    assert_equal([:name], Person0.members)

    [ Person1,
      Person2a, Person2b, Person2c,
      Person3a, Person3b, Person3c,
      Person4a, Person4b, Person4c,
      Person5,
      Person6a, Person6b, Person6c,
      Person7a, Person7b, Person7c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
      assert_equal([:first_name, :last_name], mod.members)
    end
  end

  def test_the_module_triple_equal
    person0 = Person0.new(name: '')

    assert(Person0 === person0)
    assert(Person0::Struct === person0)

    # ---

    [ Person1,
      Person2a, Person2b, Person2c,
      Person3a, Person3b, Person3c,
      Person4a, Person4b, Person4c,
      Person5,
      Person6a, Person6b, Person6c,
      Person7a, Person7b, Person7c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
      person = mod.new(first_name: '', last_name: '')

      assert(mod === person)
      assert(mod::Struct === person)
    end
  end

  def test_that_the_module_contains_a_struct
    [ Person0, Person1,
      Person2a, Person2b, Person2c,
      Person3a, Person3b, Person3c,
      Person4a, Person4b, Person4c,
      Person5,
      Person6a, Person6b, Person6c,
      Person7a, Person7b, Person7c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
        assert(mod::Struct < ::Struct)
      end
  end

  def test_the_struct_constructor_should_be_private
    [ Person0, Person1,
      Person2a, Person2b, Person2c,
      Person3a, Person3b, Person3c,
      Person4a, Person4b, Person4c,
      Person5,
      Person6a, Person6b, Person6c,
      Person7a, Person7b, Person7c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
      error = assert_raises(NoMethodError) { mod::Struct.new }

      assert_match(/private method `new' called for .*Person.+::Struct/, error.message)
    end
  end

  def test_the_micro_struct_instances
    person0 = Person0.new(name: 'Rodrigo Serradura')

    assert_instance_of(Person0::Struct, person0)

    assert_equal('Rodrigo Serradura', person0.name)

    # --

    [ Person1,
      Person2a, Person2b, Person2c,
      Person3a, Person3b, Person3c,
      Person4a, Person4b, Person4c,
      Person5,
      Person6a, Person6b, Person6c,
      Person7a, Person7b, Person7c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_instance_of(mod::Struct, person)

      assert_equal('Rodrigo', person.first_name)
      assert_equal('Serradura', person.last_name)
    end
  end

  def test_the_to_ary_method_of_micro_struct_instances
    [ Person2a, Person2b, Person2c,
      Person6a, Person6b, Person6c,
      Person9 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo', last_name: 'Serradura')

      person_first_name, person_last_name = person

      assert_equal('Rodrigo', person_first_name)
      assert_equal('Serradura', person_last_name)

      [person].each do |(first_name, last_name)|
        assert_equal('Rodrigo', first_name)
        assert_equal('Serradura', last_name)
      end
    end
  end

  ExposeHash = ->(**hash) { hash }

  def test_the_to_hash_method_of_micro_struct_instances
    [ Person3a, Person3b, Person3c,
      Person7a, Person7b, Person7c,
      Person9 ].each do |mod|
      hash = {first_name: 'Rodrigo', last_name: 'Serradura'}

      person = mod.new(**hash)

      assert_equal(hash, ExposeHash.(**person))
    end
  end

  def test_micro_struct_instances_created_from_to_proc
    [ Person4a, Person4b, Person4c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
      person = [{first_name: 'Rodrigo', last_name: 'Serradura'}].map(&mod).first

      assert_instance_of(mod::Struct, person)

      assert_equal('Rodrigo', person.first_name)
      assert_equal('Serradura', person.last_name)
    end
  end

  def test_micro_struct_instances_that_received_a_block
    [ Person6a, Person6b, Person6c,
      Person7a, Person7b, Person7c,
      Person8a, Person8b, Person8c,
      Person9 ].each do |mod|
      person = mod.new(first_name: 'Rodrigo', last_name: 'Serradura')

      assert_equal('Rodrigo Serradura', person.name)
    end
  end
end
