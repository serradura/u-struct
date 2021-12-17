# frozen_string_literal: true

module Micro::Struct
  class Factory
    require_relative 'factory/members'
    require_relative 'factory/create_struct'

    def initialize(features)
      @features = Features.require(features)
    end

    def new(*required_members, required: nil, optional: nil, &struct_block)
      members = Members.new(required_members, required, optional)

      CreateStruct.with(members, struct_block, @features)
    end
  end

  private_constant :Factory
end
