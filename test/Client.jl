using Test, ABN, JSON3

server = @async ABN.run()

# test server is up
@test String(Client.check().body) == "ok!"

# test abn generated
abn = JSON3.read(Client.generate_abn().body, Model.Abn)
@test isinteger(abn.abn)

# test abn was valid
@test JSON3.read(Client.validate_abn(abn).body).is_valid

# test an acn made from an abn is valid
# if the 3rd digit of the abn is "0" it can not be used to make an acn, hardcoded one is used in instead
acn = abn.abn % (10^9) >= 100_000_000 ? abn.abn % (10^9) : 801471421
abn_from_acn = JSON3.read(Client.acn_to_abn(acn).body, Model.Abn)
@test JSON3.read(Client.validate_abn(abn_from_acn).body).is_valid

# the or condition is due to the 3rd digit issue
@test abn_from_acn == abn skip = (acn == 801471421)
