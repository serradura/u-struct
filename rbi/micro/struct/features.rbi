# typed: strong

module Micro::Struct::Features
  FEAT_NAMES = T.type_alias { T::Array[Symbol] }
  FEAT_OPTIONS = T.type_alias { T::Hash[Symbol, T::Boolean] }
  STR_OR_SYMBOL = T.type_alias { T.any(String, Symbol) }

  module Options
    sig { params(names: FEAT_NAMES).returns(FEAT_OPTIONS) }
    def from(names:)
    end
  end

  class Config < ::Struct
    extend T::Generic

    sig { params(names: FEAT_NAMES, options: FEAT_OPTIONS).void }
    def initialize(names, options)
    end

    sig { returns(FEAT_NAMES) }
    def names; end

    sig { returns(FEAT_OPTIONS) }
    def options; end

    sig { params(name: Symbol).returns(T::Boolean) }
    def option?(name); end

    sig { params(names: Symbol).returns(T::Boolean) }
    def options?(*names); end
  end

  Names = T.let(T.unsafe, T.proc.params(arg0: T::Array[STR_OR_SYMBOL]).returns(FEAT_NAMES))

  sig {
    params(values: T::Array[STR_OR_SYMBOL]).returns(T.any(Config, Exposed))
  }
  def self.config(values)
  end
end
