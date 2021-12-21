# frozen_string_literal: true

module Micro::Struct
  module Features
    Names = ->(values) do
      NormalizeNames::AsSymbols.(values, context: 'feature')
    end

    module Options
      With = ->(bool, names) { names.each_with_object({}) { |name, memo| memo[name] = bool } }

      DISABLED =
        With.(false, [:to_ary, :to_hash, :to_proc, :features, :readonly, :instance_copy]).freeze

      def self.check(to_ary:, to_hash:, to_proc:, features:, readonly:, instance_copy:)
        { to_ary: to_ary,
          to_hash: to_hash,
          to_proc: to_proc,
          features: features, 
          readonly: readonly,
          instance_copy: instance_copy }
      end

      def self.from_names(values)
        enabled = With.(true, values)

        check(**DISABLED.merge(enabled))
      end
    end

    Config = ::Struct.new(:names, :options) do
      def option?(name)
        options.fetch(name)
      end
      
      def options?(*names)
        names.all? { |name| option?(name) }
      end

      # :nodoc:
      def exposed?
        false
      end
    end

    class Config::Exposed < Config
      # :nodoc:
      def exposed?
        true
      end
    end

    def self.config(values)
      names = Names[values]
      options = Options.from_names(names)

      return Config.new(names, options) unless options[:features]

      names.delete(:features)
      options.delete(:features)

      Config::Exposed.new(names.freeze, options.freeze).freeze
    end
  end

  private_constant :Features
end
