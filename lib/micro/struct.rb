# frozen_string_literal: true

require_relative 'struct/version'

module Micro
  module Struct
    def self.new(*keys, &block)
      struct = ::Struct.new(*keys, &block)

      struct.send(:private_class_method, :new)
      struct.send(:alias_method, :to_ary, :to_a)

      mod = Module.new
      mod.const_set(:Struct, struct)

      # The .new() method will require all of the Struct's keyword arguments.
      # We are doing this because Struct's keyword_init option doesn't do that.
      mod.module_eval(<<~RUBY, __FILE__, __LINE__ + 1)    #
        def self.new(#{struct.members.join(':, ')}:)      # def self.new(a:, b:) do
          Struct.send(:new, #{struct.members.join(', ')}) #   Struct.send(:new, a, b)
        end                                               # end

        def self.to_proc
          ->(hash) { new(**hash) }
        end
      RUBY

      mod
    end
  end
end
