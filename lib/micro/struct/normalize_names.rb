# typed: true
# frozen_string_literal: true

module Micro::Struct
  module NormalizeNames
    module AsSymbols
      REGEXP = /\A[_A-Za-z]\w*\z/.freeze
      Invalid = ->(context, val) { raise NameError.new("invalid #{context} name: #{val}") }
      AsSymbol = ->(context, val) { REGEXP =~ val ? val.to_sym : Invalid[context, val] }

      def self.call(values, context:)
        Array(values).map{ |values| AsSymbol[context, values] }
      end
    end
  end

  private_constant :NormalizeNames
end
