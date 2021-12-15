# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_Features_ToAry_Test < Minitest::Test
  Person = Micro::Struct.with(:to_ary).new(:first_name, :last_name) do
    def to_a
      [last_name, first_name]
    end
  end

  def test_that_the_to_ary_calls_to_a
    person = Person.new(first_name: 'Rodrigo', last_name: 'Serradura')

    last_name, first_name = person

    assert_equal('Rodrigo', first_name)
    assert_equal('Serradura', last_name)
  end
end
