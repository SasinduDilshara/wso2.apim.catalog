import ballerina/http;
import ballerinax/wso2.apim.catalog as _;
import ballerinax/wso2.apim.catalog as catalog;
import ballerina/graphql;
import ballerina/websocket;

@graphql:ServiceConfig {}
service / on new http:Listener(9700) {
    
}

@websocket:ServiceConfig {}
service / on new websocket:Listener(9701) {
    
}

@graphql:ServiceConfig {}
@catalog:ServiceCatalogConfig{}
service / on new http:Listener(9702) {
    
}

@catalog:ServiceCatalogConfig{
    openApiDefinition: []
}
@websocket:ServiceConfig {}
service / on new websocket:Listener(9703) {
    
}
