# frozen_string_literal: true

module RGB
  Color = Micro::Struct.with(:readonly, :to_ary).new(:red, :green, :blue) do
    def initialize(r, g, b)
      super(
        Number.new(value: r, label: 'red'),
        Number.new(value: g, label: 'green'),
        Number.new(value: b, label: 'blue')
      )
    end

    def to_a
      @to_a ||= super.map(&:value)
    end

    def to_hex
      @to_hex ||= "##{red}#{green}#{blue}"
    end
  end
end
