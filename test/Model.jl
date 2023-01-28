using ABN, Test, Pipe

begin # constructor check
    @test isa(Model.Business(), Model.Business)
    @test isa(Model.Business(1), Model.Business)
    @test_throws MethodError Model.Business("2")
    @test_throws MethodError Model.Business(1, "2")
end

# getter check
begin 
    business = Model.Business(1, 2)
    @test business.business_number == 1
    @test business.company_number == 2
    @test business.is_valid == false
end

begin # equality check
    x = Model.Business(1, 1)
    y = Model.Business(1, 2)
    @test x == y

    x = Model.Business(1, 1)
    y = Model.Business(2, 1)
    @test x != y

    x = Model.Business(nothing, 2)
    y = Model.Business(1, 2)
    @test x != y
end
