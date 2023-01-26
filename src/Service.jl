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
function append_abn_check_digit(seed::Vector{Int64})::Vector{Int64}
    # algorithm to find check digits for the seed
    weighted_sum = sum(append!([0, 0], seed) .* weighting)
    mod_89 = weighted_sum % 89
    check_digits = 89 - mod_89 + 10

    # append check digits to seed
    return append!([check_digits ÷ 10, check_digits % 10], seed)
end

"""
Randomly generates an ABN that will pass ABN Validation Rules
"""
function generate_abn()
    # random seed
    seed = rand(0:9, 9) |> append_abn_check_digit

    # transform array of digits to int
    abn = sum(seed[i] * 10^(length(seed) - i) for i ∈ eachindex(seed))
    return abn
end

"""
Converts an ACN to an ABN by appending 2 digits to the front of a ACN
"""
acn_to_abn(acn::Any) = throw(ArgumentError("acn argument must be an integer"))
function acn_to_abn(acn::Int)
    @assert length(digits(acn)) == 9 "acn must have 9 digits, had $(length(digits(acn)))"

    # acn as seed (Int => Vector{Int})
    seed = acn |> digits |> reverse |> append_abn_check_digit

    # transform array of digits to int
    abn = sum(seed[i] * 10^(length(seed) - i) for i ∈ eachindex(seed))
    return abn
end

"""
Perform the validation algorithm described on https://abr.business.gov.au/Help/AbnFormat
"""
validate_abn(abn::Any) = throw(ArgumentError("abn argument must be an integer"))
function validate_abn(abn::Int)::Bool
    @assert length(digits(abn)) == 11 "abn must have 11 digits, had $(length(digits(abn)))"

    # int to digit array
    ds = abn |> digits |> reverse

    # decrement first digit
    xs = pushfirst!(ds, popfirst!(ds) - 1)

    # weighted sum
    weighted_sum = sum(xs .* weighting)

    return weighted_sum % 89 == 0
end

end