import ballerina/http;
import ballerinax/wso2.apim.catalog as _;

listener http:Listener l = check new (9093, {
    secureSocket: {
        key: {
            path: "./resources/clientKeyStore.p12", 
            password: "password"
        }, 
        mutualSsl: {
            cert: {
                path: "./resources/clientTrustStore.p12", 
                password: "password"
                }
            }
        }
    });

listener http:Listener l2 = check new (9093, {
    secureSocket: {
        key: {
            path: "./resources/clientKeyStore.p12", 
            password: "password"
        }, 
        mutualSsl: {
            verifyClient: "OPTIONAL",
            cert: {
                path: "./resources/clientTrustStore.p12", 
                password: "password"
                }
            }
        }
    });

listener http:Listener l3 = check new (9093, {
    secureSocket: {
        key: {
            path: "./resources/clientKeyStore.p12", 
            password: "password"
        }, 
        mutualSsl: {
            verifyClient: "REQUIRE",
            cert: {
                path: "./resources/clientTrustStore.p12", 
                password: "password"
                }
            }
        }
    });

@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
service /sales0 on l {

}
