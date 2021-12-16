# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'u-struct', path: '..'
  gem 'kind'
end

require_relative 'rgb/number'
require_relative 'rgb/color'

puts

rgb_color = RGB::Color.new(red: 1, green: 1, blue: 255)

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
  RGB::Color.new(red: 1, green: -1, blue: 255)
rescue => exception
  puts exception # Kind::Error (green: -1 expected to be a kind of Integer(>= 0 and <= 255))
end
