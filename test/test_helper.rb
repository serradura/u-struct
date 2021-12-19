# frozen_string_literal: true

if RUBY_VERSION >= '2.5.0'
  require 'simplecov'

  SimpleCov.start do
    add_filter '/test/'

    enable_coverage :branch
  end
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'u-struct'

require 'minitest/pride'
require 'minitest/autorun'
