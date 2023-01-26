module Resource

using HTTP, JSON3
using ..Service, ..Model

const ROUTER = HTTP.Router()

"""
Health check endpoint for the API
"""
health_check(req) = "ok!"

generate_abn(req) = HTTP.Response(200, JSON3.write(Service.generate_abn()))

function acn_to_abn(req)
    business = JSON3.read(req.body, AustralianBusiness)
    return HTTP.Response(200, JSON3.write(Service.acn_to_abn(business.acn)))
end

function validate_abn(req)
    business = JSON3.read(req.body, AustralianBusiness)
    return HTTP.Response(200, JSON3.write(Service.validate_abn(business.abn)))
end

HTTP.register!(ROUTER, "GET", "/", health_check)
HTTP.register!(ROUTER, "GET", "/generate", generate_abn)
HTTP.register!(ROUTER, "POST", "/acn-to-abn", acn_to_abn)
HTTP.register!(ROUTER, "POST", "/validate", validate_abn)

function run()
    HTTP.serve(ROUTER, "0.0.0.0", 9111)
end

end