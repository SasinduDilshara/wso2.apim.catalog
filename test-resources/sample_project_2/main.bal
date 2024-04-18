import ballerina/http;
import ballerinax/wso2.apim.catalog as _;
import ballerina/graphql;

service /sales0/base on new http:Listener(9200) {
    
    resource function get orders() {
        
    }

    resource function post orders() {
        
    }
}

service /sales0 on new graphql:Listener(9201) {
    resource function get orders() {
        
    }

    resource function post orders() {
        
    }
}

service /sales0 on new http:Listener(9202) {
    resource function get orders() {
        
    }

    resource function post orders() {
        
    }
}
