# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_Features_ErrorName_Test < Minitest::Test
  def test_the_invalid_feature_name_error
    err = assert_raises(NameError) do
      Micro::Struct.with('1')
    end

    assert_match(/invalid feature name: 1/, err.message)
  end
end
