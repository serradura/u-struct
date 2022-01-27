# frozen_string_literal: true

module RGB
  Number = Micro::Struct.with(:readonly).new(:value, :label) do
    Input = Kind.object(name: 'Integer(>= 0 and <= 255)') do |value|
      value.is_a?(::Integer) && value >= 0 && value <= 255
    end

    def initialize(value, label)
      super(Input[value, label: label])
    end

    def to_s
      @to_s ||= format('%02x', value)
    end

    def inspect
      "#<RGB::Number #{value}>"
    end
  end
end
