using ABN, Test, Pipe

# simple tests
@test Service.check() == "ok!"

# test generate_abn makes a valid abn
@test isa(Service.generate_abn(), Model.Abn)
@test Service.generate_abn() |> Service.validate_abn! |> (x -> x.is_valid)

# test acn->abn
@test isa(Service.acn_to_abn(123456789), Model.Abn)
@test Service.acn_to_abn(123456789) |> Service.validate_abn! |> (x -> x.is_valid)
@test_throws AssertionError Service.acn_to_abn(123)
@test_throws MethodError Service.acn_to_abn("123")
@test_throws MethodError Service.acn_to_abn("123456789")

# batch test - generate_abn, acn_to_abn, and validate_abn
abns = map(x -> Service.generate_abn(), range(1, 100))
for abn ∈ abns
    @test Service.validate_abn!(abn).is_valid

    acn = abn.abn % (10^9)
    # above doesn't always generate valid acn's 
    if (acn < 100_000_000)
        continue
    end
    abn_from_acn = Service.acn_to_abn(acn)
    @test Service.validate_abn!(abn_from_acn).is_valid
end
