module Model

import Base: ==

using StructTypes

export Abn

mutable struct Abn
    abn::Union{Nothing,Int}
    acn::Union{Nothing,Int}
    is_valid::Bool # managed
end

==(x::Abn, y::Abn) = x.abn == y.abn
Abn() = Abn(nothing, nothing, false)
Abn(abn) = Abn(abn, nothing, false)
Abn(abn, acn) = Abn(abn, acn, false)
Abn(abn, acn, is_valid) = Abn(abn, acn, is_valid)
StructTypes.StructType(::Type{Abn}) = StructTypes.Mutable()
StructTypes.idproperty(::Type{Abn}) = :abn

end