# frozen_string_literal: true

module Micro::Struct
  module Features
    Names = ->(values) do
      NormalizeNames::AsSymbols.(values, context: 'feature')
    end

    module Options
      def self.check(to_ary:, to_hash:, to_proc:, readonly:, instance_copy:, exposed_features:)
        { to_ary: to_ary,
          to_hash: to_hash,
          to_proc: to_proc, 
          readonly: readonly,
          instance_copy: instance_copy,
          exposed_features: exposed_features }
      end

      With = ->(bool, names) { names.each_with_object({}) { |name, memo| memo[name] = bool } }

      DISABLED = With.(false, method(:check).parameters.map(&:last)).freeze

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
    end

    Exposed = Class.new(Config)

    def self.config(values)
      names = Names[values]
      options = Options.from_names(names)

      return Config.new(names, options) unless options[:exposed_features]

      names.delete(:exposed_features)
      options.delete(:exposed_features)

      Exposed.new(names.freeze, options.freeze).freeze
    end
  end

  private_constant :Features
end
