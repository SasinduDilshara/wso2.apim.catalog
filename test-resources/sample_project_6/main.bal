import ballerina/http;
import ballerinax/wso2.apim.catalog as _;
import ballerinax/wso2.apim.catalog as catalog;

# Example documentation
# Example documentation 2
@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
service /sales0 on new http:Listener(9600) {
}

# Example documentation
# Example documentation 2
service /sales0 on new http:Listener(9601) {
}

# Example documentation
@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
@catalog:ServiceCatalogConfig {
    openApiDefinition: []
}
service /sales0 on new http:Listener(9602) {
}

# Example documentation
# Example documentation 2
@catalog:ServiceCatalogConfig {
    openApiDefinition: []
}
@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
service /sales0 on new http:Listener(9603) {
}

#  Example documentation
@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
service /sales0 on new http:Listener(9604) {
    # Example resource doc
    resource function get path() {
        
    }
}