# frozen_string_literal: true

module Micro::Struct
  module Features
    DISABLED =
      { to_ary: false,
        to_hash: false,
        to_proc: false,
        readonly: false,
        instance_copy: false
      }.freeze

    Check = ->(to_ary:, to_hash:, to_proc:, readonly:, instance_copy:) do
      { to_ary: to_ary,
        to_hash: to_hash,
        to_proc: to_proc,
        readonly: readonly,
        instance_copy: instance_copy }
    end

    ValidateFeatureNames = ->(values) do
      Validate::Names.(values, label: 'feature')
    end

    def self.require(names)
      features_to_enable =
        ValidateFeatureNames[names].each_with_object({}) { |name, memo| memo[name] = true }

      Check.(**DISABLED.merge(features_to_enable))
    end
  end

  private_constant :Features
end
