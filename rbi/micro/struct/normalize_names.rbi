# typed: strong

module Micro::Struct::NormalizeNames
  module AsSymbols
    STR_OR_SYMBOL = T.type_alias { T.any(String, Symbol) }

    REGEXP = T.let(T.unsafe, Regexp)
    Invalid = T.let(T.unsafe, T.proc.params(arg0: String, arg1: T.any(STR_OR_SYMBOL)).void)
    AsSymbol = T.let(T.unsafe, T.proc.params(arg0: String, arg1: T.any(STR_OR_SYMBOL)).returns(Symbol))

    sig {
      params(
        values:  T.nilable(T.any(STR_OR_SYMBOL, T::Array[STR_OR_SYMBOL])),
        context: String
      ).returns(T::Array[Symbol])
    }
    def self.call(values, context:)
    end
  end
end
