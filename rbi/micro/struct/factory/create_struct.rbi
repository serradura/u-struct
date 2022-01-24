# typed: true

module Micro::Struct::Factory::CreateStruct
  extend self

  STRUCT_BLOCK = T.type_alias { T.nilable(T.proc.params(arg0: T.untyped).returns(T.untyped)) }
  STRUCT_MEMBERS = T.type_alias { Micro::Struct::Factory::Members }
  FEATURES_EXPOSED = T.type_alias { Micro::Struct::Features::Exposed }
  FEATURES_CONFIG = T.type_alias { T.any(Micro::Struct::Features::Config, FEATURES_EXPOSED) }

  sig {
    params(
      members: STRUCT_MEMBERS,
      features: FEATURES_CONFIG,
      struct_block: STRUCT_BLOCK
    ).returns(T.class_of(Struct))
  }
  def with(members, features, struct_block)
  end

  private

  def create_struct(members); end

  module ClassScope
    sig { params(struct: T.class_of(Struct), members: STRUCT_MEMBERS).void }
    def self.def_new(struct, members)
    end

    sig { params(struct: T.untyped, features: FEATURES_EXPOSED).void }
    def self.def_features(struct, features)
    end

    sig { params(struct: T.class_of(Struct)).void }
    def self.def_to_proc(struct)
    end

    sig { params(struct: T.class_of(Struct)).void }
    def self.def_private_writers(struct)
    end

    sig { params(struct: T.class_of(Struct), block: STRUCT_BLOCK).void }
    def self.evaluate(struct, block)
    end
  end

  module InstanceScope
    sig { params(struct: T.class_of(Struct)).void }
    def self.def_to_ary(struct)
    end

    sig { params(struct: T.class_of(Struct)).void }
    def self.def_to_hash(struct)
    end

    sig { params(struct: T.class_of(Struct)).void }
    def self.def_with(struct)
    end
  end
end
