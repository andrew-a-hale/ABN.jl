using ABN
using Test, JSON3, HTTP

server = @async ABN.run()

# test server is up
@test JSON3.read(Client.health_check().body).msg == "ok!"

# test generate
abn = JSON3.read(Client.generate_abn().body)
@test isinteger(abn)

# test validate
@test JSON3.read(Client.validate_abn(abn).body)
@test_throws HTTP.Exceptions.StatusError Client.validate_abn(1)
@test_throws HTTP.Exceptions.StatusError Client.validate_abn("1")

# test acn_to_abn
# test an acn made from an abn is valid
# if the 3rd digit of the abn is "0" it can not be used to make an acn, hardcoded one is used in instead
acn = abn % (10^9) >= 100_000_000 ? abn % (10^9) : 801471421
abn_from_acn = JSON3.read(Client.acn_to_abn(acn).body)
@test JSON3.read(Client.validate_abn(abn_from_acn).body)

# the or condition is due to the 3rd digit issue
@test abn_from_acn == abn skip = (acn == 801471421)

@test_throws HTTP.Exceptions.StatusError JSON3.read(Client.acn_to_abn(1))
@test_throws HTTP.Exceptions.StatusError JSON3.read(Client.acn_to_abn("1"))