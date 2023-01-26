using ABN, Test, Pipe

# constructor check
@test isa(Model.AustralianBusiness(), Model.AustralianBusiness)
@test isa(Model.AustralianBusiness(1), Model.AustralianBusiness)
@test isa(Model.AustralianBusiness(1, 2), Model.AustralianBusiness)
@test isa(Model.AustralianBusiness(1, 2, nothing, false), Model.AustralianBusiness)

# getter check
@test Model.AustralianBusiness(1).abn == 1
@test isnothing(Model.AustralianBusiness(1).acn)
@test Model.AustralianBusiness().valid_abn == false

# equality check
x = Model.AustralianBusiness(1, 2)
y = Model.AustralianBusiness(1, 3)
@test x == y

x = Model.AustralianBusiness(1, 2)
y = Model.AustralianBusiness(2, 2)
@test x != y
