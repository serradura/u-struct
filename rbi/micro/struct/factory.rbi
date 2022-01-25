# typed: strong

class Micro::Struct::Factory
  STR_OR_SYMBOL = T.type_alias { T.any(String, Symbol) }
  MEMBER_NAMES = T.type_alias { T.any(STR_OR_SYMBOL, T::Array[STR_OR_SYMBOL]) }
  STRUCT_BLOCK = T.type_alias { T.nilable(T.proc.params(arg0: T.untyped).returns(T.untyped)) }

  sig {
    params(feature_names: T::Array[T.any(String, Symbol)]).void
  }
  def initialize(feature_names)
  end

  sig { params(members: T.untyped, block:   STRUCT_BLOCK).returns(Struct) }
  def instance(**members, &block)
  end

  sig {
    params(
      required_members: STR_OR_SYMBOL,
      required:     T.nilable(MEMBER_NAMES),
      optional:     T.nilable(MEMBER_NAMES),
      struct_block: STRUCT_BLOCK
    )
    .returns(T.class_of(Struct))
  }
  def new(*required_members, required: nil, optional: nil, &struct_block)
  end

  sig {
    params(
      required_members: T::Array[STR_OR_SYMBOL],
      required:     T.nilable(MEMBER_NAMES),
      optional:     T.nilable(MEMBER_NAMES),
      struct_block: STRUCT_BLOCK
    )
    .returns(T.class_of(Struct))
  }
  def __create__(required_members, required, optional, struct_block)
  end
end
