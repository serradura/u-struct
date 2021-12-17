# frozen_string_literal: true

module Micro::Struct
  module Features
    DISABLED =
      { to_ary: false,
        to_hash: false,
        to_proc: false,
        readonly: false,
        instance_copy: false }.freeze

    Check = ->(to_ary:, to_hash:, to_proc:, readonly:, instance_copy:) do
      { to_ary: to_ary,
        to_hash: to_hash,
        to_proc: to_proc,
        readonly: readonly,
        instance_copy: instance_copy }
    end

    Names = ->(values) do
      NormalizeNames::AsSymbols.(values, context: 'feature')
    end

    def self.require(values)
      to_enable = Names[values].each_with_object({}) { |name, memo| memo[name] = true }

      Check.(**DISABLED.merge(to_enable))
    end
  end

  private_constant :Features
end
