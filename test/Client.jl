using ABN
using Test, JSON3, HTTP

server = @async ABN.run()

# test server is up
@test JSON3.read(Client.health().body).msg == "ok!"

begin # test get_business from business_number
    body = (; business_number = Service._get_business().business_number)
    business = JSON3.read(Client.get_business(body).body, Model.Business)
    @test isa(business, Model.Business)
end

begin # test get_business from company_number
    body = (; company_number = 123456789)
    business = JSON3.read(Client.get_business(body).body, Model.Business)
    @test isa(business, Model.Business)
end

begin # test validate_business
    company_number = (; company_number = 123456789)
    business = JSON3.read(Client.get_business(company_number).body, Model.Business)
    @test JSON3.read(Client.validate_business(business).body, Model.Business).is_valid

    body = (; company_number = 2)
    @test_throws HTTP.Exceptions.StatusError Client.validate_business(body)
end
