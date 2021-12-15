# frozen_string_literal: true

module RGB
  Number = Micro::Struct.with(:readonly).new(:value) do
    Input = Kind.object(name: 'Integer(>= 0 and <= 255)') do |value|
      value.is_a?(::Integer) && value >= 0 && value <= 255
    end

    def self.new(value, label:)
      __new__(value: Input[value, label: label])
    end

    def to_s
      value.to_s(16)
    end
  end
end
