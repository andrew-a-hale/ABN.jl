module Service

using ..Model
using Pipe

"""
Weights used when validating or checking digits for an ABN.
From: https://abr.business.gov.au/Help/AbnFormat
"""
const weighting = append!([10], range(1, 19, step=2))

"""
Appends 2 digits to the front of an 9 digit integer such that the 11 digit integer will pass ABN Validation Rules
"""
function _append_check_digit(seed::Vector{Int64})::Vector{Int64}
    # algorithm to find check digits for the seed
    weighted_sum = sum(append!([0, 0], seed) .* weighting)
    mod_89 = weighted_sum % 89
    check_digits = 89 - mod_89 + 10

    # append check digits to seed
    return append!([check_digits ÷ 10, check_digits % 10], seed)
end

"""
Used for testing purposes

Randomly generates an ABN that will pass ABN Validation Rules
    return Business
"""
function _get_business()
    # random seed
    seed = rand(0:9, 9) |> _append_check_digit

    # transform array of digits to int
    business_number = sum(seed[i] * 10^(length(seed) - i) for i ∈ eachindex(seed))
    return Business(business_number)
end

"""
Converts an ACN to an ABN by appending 2 digits to the front of a ACN
    input 
        - company_number: 9 digit integer
    return Business
"""
_get_business_from_company_number(company_number::Any) = throw(ArgumentError("company_number argument must be an integer"))
function _get_business_from_company_number(company_number::Int)
    @assert length(digits(company_number)) == 9 "company_number must have 9 digits, had $(length(digits(company_number)))"

    # acn as seed (Int => Vector{Int})
    seed = company_number |> digits |> reverse |> _append_check_digit

    # transform array of digits to int
    business_number = sum(seed[i] * 10^(length(seed) - i) for i ∈ eachindex(seed))
    return Model.Business(business_number, company_number)
end

"""
Get a business record
    return Business
"""
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
Perform the validation algorithm described on https://abr.business.gov.au/Help/AbnFormat
    input 
        - business_number: 11 digit integer
    return Business
"""
_validate_business(business_number::Any) = throw(ArgumentError("business_number argument must be an integer"))
function _validate_business(business_number::Int)::Bool
    @assert length(digits(business_number)) == 11 "business_number must have 11 digits, had $(length(digits(business_number)))"

    # int to digit array
    ds = business_number |> digits |> reverse

    # decrement first digit
    xs = pushfirst!(ds, popfirst!(ds) - 1)

    # weighted sum
    weighted_sum = sum(xs .* weighting)

    return weighted_sum % 89 == 0
end

"""
Update a Business record with the result of the business validation
    input 
        - Business
    return Business
"""
function validate_business!(business::Business)::Business
    business.is_valid = _validate_business(business.business_number)
    return business
end

end