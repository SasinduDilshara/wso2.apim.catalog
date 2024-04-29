import ballerina/http;
import ballerina/log;

const ACCESS_TOKEN_1 = "2YotnFZFEjr1zCsicMWpAA";
const string keyStorePassword = "ballerina";

string keystorePath = string `${currentDir}${sep}tests${sep}resources${sep}ballerinaKeystore.p12`;
public type AuthResponse record {|
    *http:Ok;
    json body?;
|};

listener http:Listener sts = new (9444, {
    secureSocket: {
        key: {
            path: keystorePath,
            password: keyStorePassword
        }
    }
});

service /oauth2 on sts {
    function init() {
        log:printInfo("Start the token server for tests on http://localhost:9444");        
    }

    resource function post token(http:Request req) returns AuthResponse {
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
