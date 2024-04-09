import ballerina/http;

ServiceSchema[] serviceSchema0 = [];
service /sales0 on new http:Listener(8080) {
    resource function post services(ServiceSchema[] schema) {
        lock { 
            serviceSchema0.push(...schema);
        }
    }
}