# typed: true
# frozen_string_literal: true

module Micro::Struct
  module Features
    module Options
      def self.from(names:)
        options = names.each_with_object({}) { |name, memo| memo[name] = true }

        {
          to_ary: options.fetch(:to_ary, false),
          to_hash: options.fetch(:to_hash, false),
          to_proc: options.fetch(:to_proc, false),
          readonly: options.fetch(:readonly, false),
          instance_copy: options.fetch(:instance_copy, false),
          exposed_features: options.fetch(:exposed_features, false)
        }
      end
    end

    Config = ::Struct.new(:names, :options) do
      def option?(name)
        options.fetch(name)
      end

      def options?(*names)
        names.all? { |name| option?(name) }
      end
    end

    Exposed = Class.new(Config)

    Names = ->(values) do
      NormalizeNames::AsSymbols.(values, context: 'feature')
    end

    def self.config(values)
      names = Names[values]
      options = Options.from(names: names)

      return Config.new(names, options) unless options[:exposed_features]

      names.delete(:exposed_features)
      options.delete(:exposed_features)

      Exposed.new(names.freeze, options.freeze).freeze
    end
  end

  private_constant :Features
end
