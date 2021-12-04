# frozen_string_literal: true

module Micro::Struct
  module NormalizeNames
    module AsSymbols
      REGEXP = /\A[_A-Za-z]\w*\z/.freeze
      Invalid = ->(context, val) { raise NameError.new("invalid #{context} name: #{val}") }
      AsSymbol = ->(context, val) { REGEXP =~ val ? val.to_sym : Invalid[context, val] }.curry

      def self.call(values, context:)
        Array(values).map(&AsSymbol[context])
      end
    end
  end

  private_constant :NormalizeNames
end
