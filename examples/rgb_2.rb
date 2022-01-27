# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'u-struct', path: '..'
  gem 'kind'
end

RGBNumber = Micro::Struct.with(:readonly).new(:value) do
  Input = Kind.object(name: 'Integer(>= 0 and <= 255)') do |value|
    value.is_a?(::Integer) && value >= 0 && value <= 255
  end

  def initialize(value)
    super(Input[value])
  end

  def to_s
    format('%02x', value)
  end

  def inspect
    "#<RGBNumber #{value}>"
  end
end

RGBColor = Micro::Struct.with(:readonly, :to_ary).new(:red, :green, :blue) do
  def self.new(r:, g:, b:)
    __new__(
      red:   RGBNumber.new(value: r),
      green: RGBNumber.new(value: g),
      blue:  RGBNumber.new(value: b)
    )
  end

  def to_a
    [red.value, green.value, blue.value]
  end

  def to_hex
    "##{red}#{green}#{blue}"
  end
end

puts

rgb_color = RGBColor.new(r: 1, g: 1, b: 255)

p rgb_color

puts
puts format('to_a: %p', rgb_color.to_a)
puts format('to_hex: %p', rgb_color.to_hex)
puts

r, g, b = rgb_color

puts format('red: %p', r)
puts format('green: %p', g)
puts format('blue: %p', b)
puts

*rgb = rgb_color

puts rgb.inspect
puts

begin
  RGBColor.new(r: 1, g: -1, b: 255)
rescue Kind::Error => exception
  puts exception # Kind::Error (-1 expected to be a kind of Integer(>= 0 and <= 255))
end
