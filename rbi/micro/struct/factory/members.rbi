# typed: strong

class Micro::Struct::Factory::Members
  STR_OR_SYMBOL = T.type_alias { T.any(String, Symbol) }
  MEMBER_NAMES  = T.type_alias { T.any(STR_OR_SYMBOL, T::Array[STR_OR_SYMBOL]) }

  sig { returns(T::Array[Symbol]) }
  attr_reader :required_and_optional

  Names = T.let(T.unsafe, T.proc.params(arg0: T.nilable(MEMBER_NAMES)).returns(T::Array[Symbol]))

  sig {
    params(
      required_members: T::Array[STR_OR_SYMBOL],
      required_option: T.nilable(MEMBER_NAMES),
      optional_option: T.nilable(MEMBER_NAMES)
    ).void
  }
  def initialize(required_members, required_option, optional_option)
  end

  class ToEval < ::Struct
    extend T::Generic

    sig {
      params(
        required: T::Array[Symbol],
        optional: T::Array[Symbol],
        required_and_optional: T::Array[Symbol]
      ).void
    }
    def initialize(required, optional, required_and_optional)
    end

    sig { returns(T::Array[Symbol]) }
    def required
    end

    sig { returns(T::Array[Symbol]) }
    def optional
    end

    sig { returns(T::Array[Symbol]) }
    def required_and_optional
    end

    sig { params(name: Symbol).returns(T::Boolean) }
    def option?(name)
    end

    sig { params(names: Symbol).returns(T::Boolean) }
    def options?(*names)
    end

    sig { returns(String) }
    def keyword_args
    end

    sig { returns(String) }
    def positional_args
    end
  end

  sig { returns(ToEval) }
  def to_eval
  end
end
