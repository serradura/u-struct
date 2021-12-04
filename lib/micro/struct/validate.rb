# frozen_string_literal: true

module Micro::Struct
  module Validate
    module Names
      REGEXP = /\A[_A-Za-z]\w*\z/.freeze
      Invalid = ->(label, val) { raise NameError.new("invalid #{label} name: #{val}") }
      AsSymbol = ->(label, val) { REGEXP =~ val ? val.to_sym : Invalid[label, val] }.curry

      def self.call(values, label:)
        Array(values).map(&Names::AsSymbol[label])
      end
    end
  end

  private_constant :Validate
end
