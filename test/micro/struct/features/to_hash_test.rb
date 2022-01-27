# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_Features_ToHash_Test < Minitest::Test
  Person = Micro::Struct.with(:to_hash).new(:f, :l) do
    def to_h
      {first_name: f, last_name: l}
    end
  end

  GetFirstAndLastName = ->(first_name:, last_name:) { [first_name, last_name] }

  def test_that_the_to_hash_calls_to_h
    person = Person.new(f: 'Rodrigo', l: 'Serradura')

    first_name, last_name = GetFirstAndLastName.(**person)

    assert_equal('Rodrigo', first_name)
    assert_equal('Serradura', last_name)
  end
end
