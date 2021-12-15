# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_Features_ToProc_Test < Minitest::Test
  Person = Micro::Struct.with(:to_proc).new(:first_name, :last_name)

  def test_the_module_to_proc_method
    people = [
      { first_name: 'Rodrigo', last_name: 'Serradura' }
    ].map(&Person)

    person = people.last

    assert_equal('Rodrigo', person.first_name)
    assert_equal('Serradura', person.last_name)
  end
end
