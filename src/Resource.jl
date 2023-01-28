module Resource

using HTTP, JSON3, SwagUI, SwaggerMarkdown
using ..Service, ..Model

const ROUTER = HTTP.Router()

# routes
# HTTP.register!(ROUTER, "GET", "/", health_check)
# HTTP.register!(ROUTER, "GET", "/generate", generate_abn)
# HTTP.register!(ROUTER, "POST", "/acn-to-abn", acn_to_abn)
# HTTP.register!(ROUTER, "POST", "/validate", validate_abn)
# HTTP.register!(ROUTER, "GET", "/docs", docs)

@swagger """
/:
    get:
        description: Health Check
        tags:
            - 'Health Check'
        responses:
            '200': 
                description: Check if the API is up
"""
health_check(req) = HTTP.Response(200, JSON3.write((; msg="ok!")))
HTTP.register!(ROUTER, "GET", "/", health_check)

@swagger """
/generate:
    get:
        description: Generate Australian Business Number
        tags:
            - 'Australian Business Number'
        responses:
            '200': 
                description: Generate an Australian Business Number
"""
generate_abn(req) = HTTP.Response(200, JSON3.write(Service.generate_abn()))
HTTP.register!(ROUTER, "GET", "/generate", generate_abn)

@swagger """
/acn-to-abn:
    post:
        description: Convert Australia Company Number
        tags:
            - 'Australian Business Number'
        responses:
            '200': 
                description: Convert an Australia Company Number to an Australia Business Number
            '400':
                description: Invalid Australia Company Number
"""
function acn_to_abn(req)
    try
        business = JSON3.read(req.body, AustralianBusiness)
        return HTTP.Response(200, JSON3.write(Service.acn_to_abn(business.acn)))
    catch e
        return HTTP.Response(400, "Error: $e")
    end
end
HTTP.register!(ROUTER, "POST", "/acn-to-abn", acn_to_abn)

@swagger """
/validate:
    post:
        description: Validate an Australian Business Number
        tags:
            - 'Australian Business Number'
        responses:
            '200': 
                description: Validate an Australian Business Number
            '400':
                description: Invalid Australian Business Number
"""
function validate_abn(req)
    try
        business = JSON3.read(req.body, AustralianBusiness)
        return HTTP.Response(200, JSON3.write(Service.validate_abn(business.abn)))
    catch e
        return HTTP.Response(400, "Error: $e")
    end
end
HTTP.register!(ROUTER, "POST", "/validate", validate_abn)

# build swagger
info = Dict{String,Any}()
info["title"] = "Australian Business Number Service"
info["version"] = "1.0.0"
openApi = OpenAPI("2.0", info)
swagger_document = build(openApi)
docs(req) = HTTP.Response(200, render_swagger(swagger_document))
HTTP.register!(ROUTER, "GET", "/docs", docs)

function run()
    HTTP.serve(ROUTER, "0.0.0.0", 9111)
end

end