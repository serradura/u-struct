# typed: strong

module Micro::Struct
  STR_OR_SYMBOL = T.type_alias { T.any(String, Symbol) }
  STRUCT_BLOCK  = T.type_alias { T.nilable(T.proc.params(arg0: T.untyped).returns(T.untyped)) }

  sig {
    params(feature_names: Symbol).returns(Micro::Struct::Factory)
  }
  def self.with(*feature_names)
  end

  sig {
    params(feature_names: Symbol).returns(Micro::Struct::Factory)
  }
  def self.[](*feature_names)
  end

  sig {
    params(
      members:  STR_OR_SYMBOL,
      required: T.nilable(T.any(STR_OR_SYMBOL, T::Array[STR_OR_SYMBOL])),
      optional: T.nilable(T.any(STR_OR_SYMBOL, T::Array[STR_OR_SYMBOL])),
      block:    STRUCT_BLOCK
    )
    .returns(T.class_of(Struct))
  }
  def self.new(*members, required: nil, optional: nil, &block)
  end

  sig {
    params(
      members: T.untyped,
      block:   STRUCT_BLOCK
    )
    .returns(Struct)
  }
  def self.instance(**members, &block)
  end

  READONLY = T.let(T::Array[Symbol])
  IMMUTABLE = T.let(T::Array[Symbol])
  EMPTY_ARRAY = T.let(T::Array)

  sig {
    params(with: T::Array[Symbol]).returns(Micro::Struct::Factory)
  }
  def readonly(with: EMPTY_ARRAY)
  end

  sig {
    params(with: T::Array[Symbol]).returns(Micro::Struct::Factory)
  }
  def immutable(with: EMPTY_ARRAY)
  end

  private

  sig {
    params(
      names: T.nilable(T::Array[Symbol]),
      defaults: T::Array[Symbol]
    )
    .returns(Micro::Struct::Factory)
  }
  def factory(names, defaults = EMPTY_ARRAY)
  end
end
