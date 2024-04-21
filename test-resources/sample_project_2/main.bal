import ballerina/http;
import ballerinax/wso2.apim.catalog as _;
import ballerina/graphql;

service /sales0/base on new http:Listener(9200) {
    
    resource function get orders() {
        
    }

    resource function post orders() {
        
    }
}

// TODO: Create and add a issue for the Graphql.
// service /sales0 on new graphql:Listener(9201) {
//     resource function get orders() returns string[] {
//         return [];
//     }

//     resource function get items() returns int[] {
//         return [];
//     }
// }

service /sales0 on new http:Listener(9202) {
    resource function get orders() {
        
    }

    resource function post orders() {
        
    }
}
