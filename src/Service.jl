module Service

using ..Model
using Pipe

export get_business, validate_business!

"""
Weights used when validating or checking digits for an ABN.

From: https://abr.business.gov.au/Help/AbnFormat
"""
const _weighting = append!([10], range(1, 19, step=2))

"""
Appends 2 digits to the front of an 9 digit integer such that the 11 digit integer will pass ABN Validation Rules
"""
function _append_check_digit(seed::Vector{Int64})::Vector{Int64}
    # algorithm to find check digits for the seed
    weighted_sum = sum(append!([0, 0], seed) .* _weighting)
    mod_89 = weighted_sum % 89
    check_digits = 89 - mod_89 + 10

    # append check digits to seed
    return append!([check_digits ÷ 10, check_digits % 10], seed)
end

"""
    _get_business() => ABN.Business

Used for testing purposes

Randomly generates an business number that will pass ABN Validation Rules
"""
function _get_business()
    # random seed
    seed = rand(0:9, 9) |> _append_check_digit

    # transform array of digits to int
    business_number = sum(seed[i] * 10^(length(seed) - i) for i ∈ eachindex(seed))
    return Business(business_number)
end

"""
    _get_business_from_company_number(company_number::Any) => ArgumentError
    _get_business_from_company_number(company_number::Int) => ABN.Business

Converts an company number to an business number by appending 2 digits to the front of a company number
"""
_get_business_from_company_number(company_number::Any) = throw(ArgumentError("company_number argument must be an integer"))
function _get_business_from_company_number(company_number::Int)
    @assert length(digits(company_number)) == 9 "company_number must have 9 digits, had $(length(digits(company_number)))"

    # company_number as seed (Int => Vector{Int})
    seed = company_number |> digits |> reverse |> _append_check_digit

    # transform array of digits to int
    business_number = sum(seed[i] * 10^(length(seed) - i) for i ∈ eachindex(seed))
    return Model.Business(business_number, company_number)
end

"""
    get_business(number::Int) => ABN.Business

Get a business record using either a company or business number
"""
get_business(number::Any) = throw(ArgumentError("argument must be an integer"))
function get_business(number::Int)
    if length(digits(number)) == 9
        return _get_business_from_company_number(number)
    elseif length(digits(number)) == 11
        return Model.Business(number)
    else
        throw(ArgumentError("number argument was not a business number or company number"))
    end
end

"""
    _validate_business(business_number::Any) => ArgumentError
    _validate_business(business_number::Int) => Bool
Perform the validation algorithm described on https://abr.business.gov.au/Help/AbnFormat
"""
_validate_business(business_number::Any) = throw(ArgumentError("business_number argument must be an integer"))
function _validate_business(business_number::Int)::Bool
    @assert length(digits(business_number)) == 11 "business_number must have 11 digits, had $(length(digits(business_number)))"

    # int to digit array
    ds = business_number |> digits |> reverse

    # decrement first digit
    xs = pushfirst!(ds, popfirst!(ds) - 1)

    # weighted sum
    weighted_sum = sum(xs .* _weighting)

    return weighted_sum % 89 == 0
end

"""
    validate_business!(business::Business) => ABN.Business

Update a Business record with the result of the business validation
"""
function validate_business!(business::Business)::Business
    business.is_valid = _validate_business(business.business_number)
    return business
end

end