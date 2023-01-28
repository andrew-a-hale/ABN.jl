using ABN, Test, Pipe

begin # test _get_business makes a valid abn
    business = Service._get_business()
    @test isa(business, Model.Business)
    @test business |> Service.validate_business! |> (x -> x.is_valid)
end

begin # test _get_business_from_company_number
    @test isa(Service._get_business_from_company_number(123456789), Model.Business)
    @test Service._get_business_from_company_number(123456789) |> Service.validate_business! |> (x -> x.is_valid)
    @test_throws AssertionError Service._get_business_from_company_number(123)
    @test_throws ArgumentError Service._get_business_from_company_number("123")
end

# batch test - get_business, get_business_from_company_number, and validate_business!
for i ∈ 1:10_000
    b = Service._get_business()

    @test b.business_number |> Service.get_business |> Service.validate_business! |> (x -> x.is_valid)

    company_number = b.business_number % (10^9)
    # above doesn't always generate a valid company_number 
    if (company_number < 100_000_000)
        continue
    end

    b = Service.get_business(company_number)
    @test b |> Service.validate_business! |> (x -> x.is_valid)
end
