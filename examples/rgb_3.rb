# frozen_string_literal: true

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'u-struct', path: '..'
  gem 'kind'
end

require_relative 'rgb/number'
require_relative 'rgb/color'

rgb_color = RGB::Color.new(r: 1, g: 1, b: 255)

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
