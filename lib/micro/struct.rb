# frozen_string_literal: true

require_relative 'struct/version'
require_relative 'struct/features'
require_relative 'struct/creator'
require_relative 'struct/validate'

module Micro
  # Like in a regular Struct, you can define one or many attributes.
  # But all of will be required by default.
  #
  #   Micro::Struct.new(:first_name, :last_name, ...)
  #
  # Use the `_optional:` arg if you want some optional attributes.
  #
  #   Micro::Struct.new(:first_name, :last_name, _optional: :gender)
  #
  # Using `_optional:` to define all attributes are optional.
  #
  #   Micro::Struct.new(_optional: [:first_name, :last_name])
  #
  # You can also pass a block to define custom methods.
  #
  #   Micro::Struct.new(:name) {}
  #
  # Available features (use one, many, or all) to create Structs with a special behavior:
  # .with(:to_ary, :to_hash, :to_proc, :readonly, :instance_copy)
  #
  #   Micro::Struct.with(:to_ary).new(:name)
  #   Micro::Struct.with(:to_ary, :to_hash).new(:name)
  #   Micro::Struct.with(:to_ary, :to_hash, :to_proc).new(:name)
  #   Micro::Struct.with(:to_ary, :to_hash, :to_proc, :readonly).new(:name)
  #   Micro::Struct.with(:to_ary, :to_hash, :to_proc, :readonly, :instance_copy).new(:name)
  #
  # All of the possible combinations to create a Ruby Struct. ;)
  #
  #   Micro::Struct.new(*required)
  #   Micro::Struct.new(*required) {}
  #
  #   Micro::Struct.new(_optional: *)
  #   Micro::Struct.new(_optional: *) {}
  #
  #   Micro::Struct.new(*required, _optional: *)
  #   Micro::Struct.new(*required, _optional: *) {}
  #
  # Any options above can be used by the `.new()` method of the struct creator returned by the `.with()` method.
  #
  #   Micro::Struct.with(*features).new(...) {}
  module Struct
    def self.new(*members, _optional: nil, &block)
      with.new(*members, _optional: _optional, &block)
    end

    def self.with(*features)
      Creator.new(features)
    end
  end
end
