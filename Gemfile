# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in micro-struct.gemspec
gemspec

gem 'rake', '13.0.6'

gem 'minitest', '5.15.0'

if RUBY_VERSION >= '2.5.0'
  gem 'rubocop',          '1.26'
  gem 'rubocop-minitest', '0.18.0'
  gem 'rubocop-rake',     '0.6.0'
  gem 'simplecov',        '0.21.2'
end

if RUBY_VERSION >= '2.7.0'
  gem 'sorbet', '0.5.9775'
  gem 'tapioca', '0.7.0'
end
