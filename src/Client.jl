module Client

using HTTP, JSON3
using ..Model

const SERVER = Ref{String}("http://localhost:9111")

function check()
    return HTTP.get(string(SERVER[], "/"))
end

function generate_abn()
    return HTTP.get(string(SERVER[], "/generate"))
end

function acn_to_abn(acn)
    abn = Abn(nothing, acn)
    return HTTP.post(string(SERVER[], "/acn-to-abn"), body=JSON3.write(abn))
end

function validate_abn(abn)
    return HTTP.post(string(SERVER[], "/validate"), body=JSON3.write(abn))
end

end