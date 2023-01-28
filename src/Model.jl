module Model

import Base: ==

using StructTypes

export Business

abstract type AbstractBusiness end

mutable struct Business <: AbstractBusiness
    business_number::Union{Nothing,Int}
    company_number::Union{Nothing,Int}
    name::Union{Nothing,String}
    is_valid::Bool # managed
end

==(x::Business, y::Business) = x.business_number == y.business_number
Business() = Business(nothing, nothing, nothing, false)
Business(business_number::Int) = Business(business_number, nothing, nothing, false)
Business(business_number::Union{Nothing,Int}, company_number::Int) = Business(business_number, company_number, nothing, false)
StructTypes.StructType(::Type{Business}) = StructTypes.Mutable()
StructTypes.idproperty(::Type{Business}) = :business_number

end