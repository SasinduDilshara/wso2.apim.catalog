import ballerina/http;
import ballerina/log;

const ACCESS_TOKEN_1 = "2YotnFZFEjr1zCsicMWpAA";
const string keyStorePassword = "ballerina";

string keystorePath = string `${currentDir}/tests/resources/ballerinaKeystore.p12`;
public type AuthResponse record {|
    *http:Ok;
    json body?;
|};

listener http:Listener sts = new (9443, {
    secureSocket: {
        key: {
            path: keystorePath,
            password: keyStorePassword
        }
    }
});

service /oauth2 on sts {
    function init() {
        log:printInfo("Start the token server");        
    }

    resource function post token(http:Request req) returns AuthResponse {
        log:printInfo("Executing token endpoint");
        return {
            body: {
                "access_token": ACCESS_TOKEN_1,
                "token_type": "example",
                "expires_in": 3600,
                "example_parameter": "example_value"
            }
        };
    }

    resource function post introspect(http:Request request) returns AuthResponse {
        return {
            body: {"active": true, "exp": 3600, "scp": "write update"}
        };
    }
}