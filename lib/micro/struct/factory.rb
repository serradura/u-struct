# typed: true
# frozen_string_literal: true

module Micro::Struct
  class Factory
    require_relative 'factory/members'
    require_relative 'factory/create_struct'

    def initialize(feature_names)
      @features = Features.config(feature_names)
    end

    def __create__(required_members, required, optional, struct_block) # :nodoc:
      members = Members.new(required_members, required, optional)

      CreateStruct.with(members, @features, struct_block)
    end

    def new(*required_members, required: nil, optional: nil, &struct_block)
      __create__(required_members, required, optional, struct_block)
    end

    def instance(**members, &block)
      __create__(members.keys, nil, nil, block).new(**members)
    end
  end

  private_constant :Factory
end
