using ABN, Test, Pipe

# constructor check
@test isa(Model.Abn(), Model.Abn)
@test isa(Model.Abn(1), Model.Abn)
@test isa(Model.Abn(1, 2), Model.Abn)
@test isa(Model.Abn(1, 2, false), Model.Abn)

# getter check
@test Model.Abn(1).abn == 1
@test isnothing(Model.Abn(1).acn)
@test Model.Abn(nothing, 2).acn == 2
@test Model.Abn().is_valid == false

# equality check
x = Model.Abn(1, 2)
y = Model.Abn(1, 3)
@test x == y

x = Model.Abn(1, 2)
y = Model.Abn(2, 2)
@test x != y
