using ABN, Test, Pipe

# test generate_abn makes a valid abn
@test isinteger(Service.generate_abn())
@test Service.generate_abn() |> Service.validate_abn

# test acn->abn
@test isinteger(Service.acn_to_abn(123456789))
@test Service.acn_to_abn(123456789) |> Service.validate_abn
@test_throws AssertionError Service.acn_to_abn(123)
@test_throws ArgumentError Service.acn_to_abn("123")

# test validate_abn
@test_throws AssertionError Service.validate_abn(1)
@test_throws ArgumentError Service.validate_abn("a")
@test Service.validate_abn(11_111_111_111) == false

# batch test - generate_abn, acn_to_abn, and validate_abn
for i ∈ 1:10_000
    abn = Service.generate_abn()
    @test Service.validate_abn(abn)

    acn = abn % (10^9)
    # above doesn't always generate valid acn's 
    if (acn < 100_000_000)
        continue
    end
    
    abn_from_acn = Service.acn_to_abn(acn)
    @test Service.validate_abn(abn_from_acn)
end
