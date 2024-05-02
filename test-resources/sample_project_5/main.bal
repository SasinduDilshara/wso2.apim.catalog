import ballerina/http;
import ballerinax/wso2.apim.catalog as _;
import ballerina/openapi;

@http:ServiceConfig {
    host: "www.example.com"
}
service /sales0 on new http:Listener(9500) {
}

@http:ServiceConfig {
    host: "localhost"
}
service /sales0 on new http:Listener(9501) {
}

@http:ServiceConfig {
    host: ""
}
service /sales0 on new http:Listener(9502) {
}

@openapi:ServiceInfo {
    'version: "1.0.0"
}
service /sales0 on new http:Listener(9503) {
}

@openapi:ServiceInfo {
    'version: "4.1.2"
}
@http:ServiceConfig {
    host: "www.example.com"
}
service /sales0 on new http:Listener(9504) {
}

// This test case disable due to issue:- https://github.com/ballerina-platform/ballerina-library/issues/6477
// @http:ServiceConfig {
//     host: "www.example.com"
// }
// @openapi:ServiceInfo {
//     'version: ()
// }
// service /sales0 on new http:Listener(9505) {
// }

@openapi:ServiceInfo {
    'version: ""
}
service /sales0 on new http:Listener(9506) {
}
