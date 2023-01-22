module Service

using ..Model
using Pipe

const weighting = append!([10], range(1, 19, step=2))

function check()
  "ok!"
end

function append_abn_check_digit(seed::Vector{Int64})::Vector{Int64}
  # algorithm to find check digits for the seed
  weighted_sum = sum(append!([0, 0], seed) .* weighting)
  mod_89 = weighted_sum % 89
  check_digits = 89 - mod_89 + 10

  # append check digits to seed
  return append!([check_digits ÷ 10, check_digits % 10], seed)
end

function generate_abn()
  # random seed
  seed = rand(0:9, 9) |> append_abn_check_digit

  # transform array of digits to int
  abn = sum(seed[i] * 10^(length(seed) - i) for i ∈ eachindex(seed))
  return Model.Abn(abn)
end

function acn_to_abn(acn::Int)
  @assert length(digits(acn)) == 9 "acn must have 9 digits, had $(length(digits(acn)))"

  # acn as seed (Int => Vector{Int})
  seed = acn |> digits |> reverse |> append_abn_check_digit

  # transform array of digits to int
  abn = sum(seed[i] * 10^(length(seed) - i) for i ∈ eachindex(seed))
  return Model.Abn(abn, acn)
end

function weighted_abn_sum(abn::Int)::Int
  @assert length(digits(abn)) == 11 "abn must have 11 digits, had $(length(digits(abn)))"

  # int to digit array
  ds = abn |> digits |> reverse

  # decrement first digit
  xs = pushfirst!(ds, popfirst!(ds) - 1)

  # weighted sum
  return sum(xs .* weighting)
end

function validate_abn!(abn::Abn)
  abn.is_valid = weighted_abn_sum(abn.abn) % 89 == 0
  return abn
end

end
