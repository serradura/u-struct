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

  def self.new(value, label:)
    __new__(value: Input[value, label: label])
  end

  def to_s
    value.to_s(16)
  end
end

RGBColor = Micro::Struct.with(:readonly, :to_ary).new(:red, :green, :blue) do
  def self.new(r:, g:, b:)
    __new__(
      red:   RGBNumber.new(r, label: 'r'),
      green: RGBNumber.new(g, label: 'g'),
      blue:  RGBNumber.new(b, label: 'b')
    )
  end

  def to_a
    [red.value, green.value, blue.value]
  end

  def to_hex
    "##{red}#{green}#{blue}"
  end
end

rgb_color = RGBColor.new(r: 1, g: 1, b: 255)

p rgb_color

puts
puts format('to_hex: %p', rgb_color.to_hex)
puts format('to_a: %p', rgb_color.to_a)
puts

r, g, b = rgb_color

puts format('red: %p', r)
puts format('green: %p', g)
puts format('blue: %p', b)

RGB::Color.new(r: 1, g: -1, b: 255) # Kind::Error (g: -1 expected to be a kind of Integer(>= 0 and <= 255))
