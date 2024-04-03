import ballerina/http;
import ballerina/jballerina.java;

configurable string url = "?";
configurable string user = "?";
configurable string password = "?";
configurable string clientId = "?";
configurable string clientSecret = "?";
configurable int port = 9090;

final string catalogClientUrl = string `http://localhost:${port}`;

// final Client apimClient = check new ({auth: {username: user, password, clientId, clientSecret}});
final http:Client catalogClient = check new (catalogClientUrl);

listener Listener 'listener = new Listener(9090);

service / on 'listener {

}

public class Listener {
    int port;
    public function 'start() returns error? {
        ServiceArtifact[] artifacts = getArtifacts();
        check publishArtifacts(artifacts);
    }

    public function gracefulStop() returns error? {

    }

    public function immediateStop() returns error? {

    }

    public function detach(service object {} s) returns error? {

    }

    public function attach(service object {} s, string[]? name = ()) returns error? {

    }

    public function init(int port) {
        self.port = port;
    }
}

isolated function publishArtifacts(ServiceArtifact[] artifacts) returns error? = @java:Method {
    'class: "io.ballerina.wso2.apim.catalog.ServiceCatalog"
} external;

isolated function getArtifacts() returns ServiceArtifact[] = @java:Method {
    'class: "io.ballerina.wso2.apim.catalog.ServiceCatalog"
} external;