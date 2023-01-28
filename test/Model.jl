using ABN, Test, Pipe

# constructor check
@test isa(Model.AustralianBusiness(), Model.AustralianBusiness)
@test isa(Model.AustralianBusiness(1), Model.AustralianBusiness)
@test isa(Model.AustralianBusiness(1, 2, "A"), Model.AustralianBusiness)

# getter check
business = Model.AustralianBusiness(1, 2, "MyBusiness", false)
@test business.abn == 1
@test business.acn == 2
@test business.valid_abn == false
@test business.name == "MyBusiness"

# equality check
x = Model.AustralianBusiness(1, nothing, "A", false)
y = Model.AustralianBusiness(1, nothing, "B", false)
@test x == y

x = Model.AustralianBusiness(1, nothing, "A", false)
y = Model.AustralianBusiness(2, nothing, "B", false)
@test x != y

x = Model.AustralianBusiness(nothing, 2, "A", false)
y = Model.AustralianBusiness(1, 2, "A", false)
@test x != y
