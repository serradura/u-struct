# frozen_string_literal: true

module Micro::Struct
  class Factory
    require_relative 'factory/create_struct'

    def initialize(features)
      @features = Features.require(features)
    end

    NormalizeMemberNames = ->(values) do
      NormalizeNames::AsSymbols.(values, context: 'member')
    end

    def new(*members, required: nil, optional: nil, &block)
      optional_members = NormalizeMemberNames[optional]
      required_members = NormalizeMemberNames[members] + NormalizeMemberNames[required]

      CreateStruct.with(required_members, optional_members, @features, &block)
    end
  end

  private_constant :Factory
end
