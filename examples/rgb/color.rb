# frozen_string_literal: true

module RGB
  Color = Micro::Struct.with(:readonly, :to_ary).new(:red, :green, :blue) do
    def self.new(r:, g:, b:)
      __new__(
        red:   Number.new(r, label: 'r'),
        green: Number.new(g, label: 'g'),
        blue:  Number.new(b, label: 'b')
      )
    end

    def to_a
      super.map(&:value)
    end

    def to_hex
      "##{red}#{green}#{blue}"
    end
  end
end
