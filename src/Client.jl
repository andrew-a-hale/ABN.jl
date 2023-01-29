module Client

using HTTP, JSON3
using ..Model

const SERVER = Ref{String}("http://localhost:80")

function health()
    return HTTP.get(string(SERVER[], "/"))
end

function get_business(business)
    return HTTP.post(string(SERVER[], "/business"), body=JSON3.write(business))
end

function validate_business(business)
    return HTTP.post(string(SERVER[], "/validation/business"), body=JSON3.write(business))
end

end