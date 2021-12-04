# frozen_string_literal: true

module Micro::Struct
  class Creator
    require_relative 'creator/create_module'
    require_relative 'creator/create_struct'

    def initialize(features)
      @features = Features.require(features)
    end

    ValidateMemberNames = ->(values) do
      Validate::Names.(values, label: 'member')
    end

    def new(*members, _optional: nil, &block)
      required_members = ValidateMemberNames[members]
      optional_members = ValidateMemberNames[_optional]

      container = CreateModule.with(required_members, optional_members, @features)
      struct = CreateStruct.with(required_members, optional_members, @features, &block)

      container.const_set(:Struct, struct)
      struct.const_set(:Container, container)
    end
  end

  private_constant :Creator
end
