module Resource

using HTTP, JSON3, SwagUI, SwaggerMarkdown
using ..Service, ..Model

const ROUTER = HTTP.Router()

# routes
# HTTP.register!(ROUTER, "GET", "/", health)
# HTTP.register!(ROUTER, "POST", "/business", get_business)
# HTTP.register!(ROUTER, "POST", "/validation/business", validate_business)
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
health(req) = HTTP.Response(200, JSON3.write((; msg="ok!")))
HTTP.register!(ROUTER, "GET", "/", health)

@swagger """
/business:
    post:
        description: Get a business record
        requestBody:
            required: true
            content: 
                application/json:
                    schema:
                        type: object
                        properties:
                            business_number:
                                type: integer
                            company_number:
                                type: integer
        tags:
            - Business
        responses:
            '200': 
                description: Generate an Australian Business Number
                content:
                    application/json:
                        schema:
                            type: object
                            properties:
                                business_number:
                                    type: integer
                                company_number:
                                    type: integer
                                name:
                                    type: string
                                is_valid:
                                    type: boolean
"""
function get_business(req)
    try
        business = req.body |> JSON3.read |> values |> first
        HTTP.Response(200, JSON3.write(Service.get_business(business)))
    catch e
        return HTTP.Response(400, "Error: $e")
    end
end
HTTP.register!(ROUTER, "POST", "/business", get_business)

@swagger """
/validation/business:
    post:
        description: Validate a Business
        requestBody:
            required: true
            content: 
                application/json:
                    schema:
                        type: object
                        properties:
                            business_number:
                                type: integer
        tags:
            - Business
        responses:
            '200': 
                description: Validate a Business 
                content:
                    application/json:
                        schema:
                            type: object
                            properties:
                                business_number:
                                    type: integer
                                company_number:
                                    type: integer
                                name:
                                    type: string
                                is_valid:
                                    type: boolean
            '400':
                description: Invalid Business         
"""
function validate_business(req)
    try
        business = JSON3.read(req.body, Model.Business)
        return HTTP.Response(200, JSON3.write(Service.validate_business!(business)))
    catch e
        return HTTP.Response(400, "Error: $e")
    end
end
HTTP.register!(ROUTER, "POST", "/validation/business", validate_business)

# build swagger
info = Dict{String,Any}()
info["title"] = "Australian Business Number Service"
info["version"] = "1.0.0"
openApi = OpenAPI("3.0", info)
swagger_document = build(openApi)
docs(req) = HTTP.Response(200, render_swagger(swagger_document))
HTTP.register!(ROUTER, "GET", "/docs", docs)

function run()
    HTTP.serve(ROUTER, "0.0.0.0", 9111)
end

end