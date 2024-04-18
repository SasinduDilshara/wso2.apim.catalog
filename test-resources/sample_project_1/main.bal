import ballerina/http;
import ballerinax/wso2.apim.catalog as _;
import ballerinax/wso2.apim.catalog as catalog;
import ballerina/graphql;
import ballerina/websocket;

# This is a example documentation
@http:ServiceConfig{}
@graphql:ServiceConfig{}
@websocket:ServiceConfig{}
service /sales0 on new http:Listener(9100) {
    
}

@http:ServiceConfig{}
@catalog:ServiceCatalogConfig{}
@websocket:ServiceConfig{}
service /sales0 on new http:Listener(9101) {
    
}

@catalog:ServiceCatalogConfig{}
@http:ServiceConfig{}
@websocket:ServiceConfig{}
service /sales0 on new http:Listener(9102) {
    
}

@http:ServiceConfig{}
@websocket:ServiceConfig{}
@catalog:ServiceCatalogConfig{}
service /sales0 on new http:Listener(9103) {
    
}
