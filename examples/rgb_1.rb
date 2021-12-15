# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'u-struct', path: '..'
  gem 'kind'
end

RGBColor = Micro::Struct.with(:readonly, :to_ary).new(:red, :green, :blue) do
  def to_hex
    "##{red.to_s(16)}#{green.to_s(16)}#{blue.to_s(16)}"
  end
end

module RGBColor
  ColorNumber = Kind.object(name: 'Integer(>= 0 and <= 255)') do |value|
    value.is_a?(::Integer) && value >= 0 && value <= 255
  end

  def self.new(r:, g:, b:)
    __new__(
      red:   ColorNumber[r, label: 'r'],
      green: ColorNumber[g, label: 'g'],
      blue:  ColorNumber[b, label: 'b']
    )
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

RGBColor.new(r: 1, g: -1, b: 255) # Kind::Error (g: -1 expected to be a kind of Integer(>= 0 and <= 255))
