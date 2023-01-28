module Model

import Base: ==

using StructTypes

export AustralianBusiness

abstract type AbstractBusiness end

mutable struct AustralianBusiness <: AbstractBusiness
    abn::Union{Nothing,Int}
    acn::Union{Nothing,Int}
    name::Union{Nothing,String}
    valid_abn::Bool # managed
end

==(x::AustralianBusiness, y::AustralianBusiness) = x.abn == y.abn
AustralianBusiness() = AustralianBusiness(nothing, nothing, nothing, false)
AustralianBusiness(abn::Int) = AustralianBusiness(abn, nothing, nothing, false)
AustralianBusiness(abn::Int, acn::Int, name::String) = AustralianBusiness(abn, acn, name, false)
StructTypes.StructType(::Type{AustralianBusiness}) = StructTypes.Mutable()
StructTypes.idproperty(::Type{AustralianBusiness}) = :abn

end