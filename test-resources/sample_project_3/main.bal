import ballerina/http;
import ballerinax/wso2.apim.catalog as _;
import ballerinax/wso2.apim.catalog as catalog;

@catalog:ServiceCatalogConfig{}
service /sales0 on new http:Listener(9300) {
}

@catalog:ServiceCatalogConfig{
    openApiDefinition: []
}
service /sales0 on new http:Listener(9301) {
}

@catalog:ServiceCatalogConfig{
    openApiDefinition: "ABCDEF".toBytes()
}
service /sales0 on new http:Listener(9302) {
}

