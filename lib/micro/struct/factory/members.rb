# frozen_string_literal: true

module Micro::Struct
  class Factory
    class Members
      attr_reader :required_and_optional

      Names = ->(values) { NormalizeNames::AsSymbols.(values, context: 'member') }

      def initialize(required_members, required_option, optional_option)
        @required = Names[required_members] + Names[required_option]
        @optional = Names[optional_option]

        @required_and_optional = @required + @optional
      end

      ToEval = ::Struct.new(:required, :optional, :required_and_optional) do
        def keyword_args
          required_kargs = "#{required.join(':, ')}#{':' unless required.empty?}"
          optional_kargs = "#{optional.join(': nil, ')}#{': nil' unless optional.empty?}"

          [required_kargs, optional_kargs].reject(&:empty?).join(', ')
        end

        def positional_args
          required_and_optional.join(', ')
        end
      end

      def to_eval
        @to_eval ||= ToEval.new(@required, @optional, required_and_optional)
      end
    end

    private_constant :Members
  end
end
