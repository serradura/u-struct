# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'u-struct', path: '..'
end

RGBColor = Micro::Struct.with(:readonly, :to_ary).new(:red, :green, :blue) do
  Number = ->(value) do
    return value if value.is_a?(::Integer) && value >= 0 && value <= 255

    raise TypeError.new("#{value} must be an Integer(>= 0 and <= 255)")
  end

  def initialize(r, g, b)
    super(Number[r], Number[g], Number[b])
  end

  def to_hex
    format('#%<r>02x%<g>02x%<b>02x', r: red, g: green, b: blue)
  end
end

puts

rgb_color = RGBColor.new(red: 1, green: 1, blue: 255)

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
  RGBColor.new(red: 1, green: -1, blue: 255)
rescue TypeError => exception
  puts exception # TypeError (-1 must be an Integer(>= 0 and <= 255))
end
