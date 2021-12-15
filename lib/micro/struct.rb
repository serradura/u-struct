# frozen_string_literal: true

require_relative 'struct/version'
require_relative 'struct/features'
require_relative 'struct/factory'
require_relative 'struct/normalize_names'

module Micro
  # Like in a regular Struct, you can define one or many attributes.
  # But all of them will be required by default.
  #
  #   Micro::Struct.new(:first_name, :last_name, ...)
  #
  # Use the `optional:` arg if you want some optional attributes.
  #
  #   Micro::Struct.new(:first_name, :last_name, optional: :gender)
  #
  # Using `optional:` to define all attributes are optional.
  #
  #   Micro::Struct.new(optional: [:first_name, :last_name])
  #
  # Use the `required:` arg to define required attributes.
  #
  #   Micro::Struct.new(
  #     required: [:first_name, :last_name],
  #     optional: [:gender, :age]
  #   )
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
  #   Micro::Struct.new(optional: *)
  #   Micro::Struct.new(optional: *) {}
  #
  #   Micro::Struct.new(required: *)
  #   Micro::Struct.new(required: *) {}
  #
  #   Micro::Struct.new(*required, optional: *)
  #   Micro::Struct.new(*required, optional: *) {}
  #
  #   Micro::Struct.new(required: *, optional: *)
  #   Micro::Struct.new(required: *, optional: *) {}
  #
  # Any options above can be used by the `.new()` method of the struct creator returned by the `.with()` method.
  #
  #   Micro::Struct.with(*features).new(...) {}
  module Struct
    def self.new(*members, required: nil, optional: nil, &block)
      with.new(*members, required: required, optional: optional, &block)
    end

    def self.with(*features)
      Factory.new(features)
    end
  end
end
