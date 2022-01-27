# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in micro-struct.gemspec
gemspec

gem 'rake', '~> 13.0'

gem 'minitest', '~> 5.0'

if RUBY_VERSION >= '2.5.0'
  gem 'rubocop',          '~> 1.25'
  gem 'rubocop-minitest', '~> 0.17.0'
  gem 'rubocop-rake',     '~> 0.6.0'
  gem 'simplecov',        '~> 0.21.2'
end

if RUBY_VERSION >= '2.7.0'
  gem 'sorbet',  '~> 0.5.9542'
  gem 'tapioca', '~> 0.6.2'
end
