# frozen_string_literal: true

require 'test_helper'

class Micro::Factory_Methods_Test < Minitest::Test
  def test_the_with_alias_method
    assert_equal(
      Micro::Struct.method(:with).original_name,
      Micro::Struct.method(:[]).original_name
    )
  end
end
