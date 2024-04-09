import ballerina/http;

ServiceSchema[] serviceSchema0 = [];
ServiceSchema[] serviceSchema1 = [];
ServiceSchema[] serviceSchema2 = [];
ServiceSchema[] serviceSchema3 = [];
ServiceSchema[] serviceSchema4 = [];
ServiceSchema[] serviceSchema5 = [];
ServiceSchema[] serviceSchema6 = [];
ServiceSchema[] serviceSchema7 = [];
ServiceSchema[] serviceSchema8 = [];
ServiceSchema[] serviceSchema9 = [];
ServiceSchema[] serviceSchema10 = [];
ServiceSchema[] serviceSchema11 = [];
ServiceSchema[] serviceSchema12 = [];

service /sales0 on new http:Listener(8099) {
    resource function post services(ServiceSchema[] schema) {
        lock { 
            serviceSchema0.push(...schema);
        }
    }
}

// service /sales1 on new http:Listener(8081) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema1.push(...schema);
//         }
//     }
// }

// service /sales2 on new http:Listener(8082) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema2.push(...schema);
//         }
//     }
// }

// service /sales3 on new http:Listener(8083) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema3.push(...schema);
//         }
//     }
// }

// service /sales4 on new http:Listener(8084) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema4.push(...schema);
//         }
//     }
// }

// service /sales5 on new http:Listener(8085) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema5.push(...schema);
//         }
//     }
// }

// service /sales6 on new http:Listener(8086) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema6.push(...schema);
//         }
//     }
// }

// service /sales7 on new http:Listener(8087) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema7.push(...schema);
//         }
//     }
// }

// service /sales8 on new http:Listener(8088) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema8.push(...schema);
//         }
//     }
// }

// service /sales9 on new http:Listener(8089) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema9.push(...schema);
//         }
//     }
// }

// service /sales10 on new http:Listener(8090) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema10.push(...schema);
//         }
//     }
// }

// service /sales11 on new http:Listener(8091) {
//     resource function post services(ServiceSchema[] schema) {
//         lock { 
//             serviceSchema11.push(...schema);
//         }
//     }
// }
