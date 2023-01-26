module Client

using HTTP, JSON3
using ..Model

const SERVER = Ref{String}("http://localhost:9111")

function health_check()
    return HTTP.get(string(SERVER[], "/"))
end

function generate_abn()
    return HTTP.get(string(SERVER[], "/generate"))
end

function acn_to_abn(acn)
    business = AustralianBusiness(nothing, acn)
    return HTTP.post(string(SERVER[], "/acn-to-abn"), body=JSON3.write(business))
end

function validate_abn(abn)
    business = AustralianBusiness(abn)
    return HTTP.post(string(SERVER[], "/validate"), body=JSON3.write(business))
end

end