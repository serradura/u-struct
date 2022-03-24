# frozen_string_literal: true

require 'test_helper'

class Micro::Struct_Features_ExposedFeatures_Test < Minitest::Test
  Person0 = Micro::Struct.new(:name)
  Person1 = Micro::Struct[:readonly].new(:name)

  def test_the_struct_does_not_have_the_features_methods
    refute_respond_to Person0, :features
    refute_respond_to Person1, :features

    refute_respond_to Person0, :__features__
    refute_respond_to Person1, :__features__
  end

  Person2 = Micro::Struct.with(:exposed_features).new(:name)
  Person3 = Micro::Struct[:exposed_features, :readonly, :to_proc].new(:name)

  def test_the_struct_has_the_features_methods
    assert_respond_to Person2, :features
    assert_respond_to Person3, :features

    assert_respond_to Person2, :__features__
    assert_respond_to Person3, :__features__
  end

  def test_the_struct_exposes_its_features_configuration
    assert_same Person2.features, Person2.features
    assert_same Person3.features, Person3.features

    assert_predicate Person2.features, :frozen?
    assert_predicate Person3.features, :frozen?

    assert_predicate Person2.features, :frozen?
    assert_predicate Person3.features, :frozen?

    assert_empty Person2.features.names
    assert_equal [:readonly, :to_proc], Person3.features.names

    assert_predicate Person2.features.options, :frozen?
    assert_predicate Person3.features.options, :frozen?

    assert_equal(
      {to_ary: false, to_hash: false, to_proc: false, readonly: false, instance_copy: false},
      Person2.features.options
    )
    assert_equal(
      {to_ary: false, to_hash: false, to_proc: true, readonly: true, instance_copy: false},
      Person3.features.options
    )

    [:to_ary, :to_hash, :to_proc, :readonly, :instance_copy].each do |feature_name|
      refute Person2.features.option?(feature_name)
      refute Person2.features.options?(feature_name)
    end

    [:to_ary, :to_hash, :instance_copy].each do |feature_name|
      refute Person3.features.option?(feature_name)
      refute Person3.features.options?(feature_name)
    end

    assert Person3.features.option?(:to_proc)
    assert Person3.features.option?(:readonly)

    assert Person3.features.options?(:to_proc)
    assert Person3.features.options?(:readonly)
    assert Person3.features.options?(:to_proc, :readonly)
  end
end
