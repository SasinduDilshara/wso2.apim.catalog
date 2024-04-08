import ballerina/jballerina.java;
import ballerina/oauth2 as _;

configurable string serviceUrl = "https://apis.wso2.com/api/service-catalog/v1";
configurable string user = "?";
configurable string password = "?";
configurable string clientId = "?";
configurable string clientSecret = "?";
configurable string tokenUrl = "https://localhost:9443/oauth2/token";
configurable int port = 5050;

final Client apimClient = check new (serviceUrl = serviceUrl, config = {auth: {username: user, password, clientId, clientSecret, tokenUrl}});
final string apimCatalogUrl = "/services";

listener Listener 'listener = new Listener(port);

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

function publishArtifacts(ServiceArtifact[] artifacts) returns error? {
    boolean errorFound = false;
    error? e = null;
    foreach ServiceArtifact artifact in artifacts {
        string name = artifact.name;
        string definitionFile = artifact.definitionFile;
        Service|error res = apimClient->/services.post({
            serviceMetadata: {
                name,
                description: artifact.description,
                version: artifact.version,
                serviceKey: artifact.serviceKey,
                serviceUrl: artifact.serviceUrl,
                definitionType: artifact.definitionType,
                securityType: artifact.securityType,
                mutualSSLEnabled: artifact.mutualSSLEnabled,
                usage: artifact.usage,
                createdTime: artifact.createdTime,
                lastUpdatedTime: artifact.lastUpdatedTime,
                md5: artifact.md5,
                definitionUrl: artifact.definitionUrl
            },
            definitionFile: {fileContent: definitionFile.toBytes(), fileName: name},
            inlineContent: definitionFile
        });

        // If there is an error, wait until other artifacts get published
        if !errorFound && res is error {
            e = res;
            errorFound = true;
        }
    }

    if errorFound {
        return e;
    }
}

isolated function getArtifacts() returns ServiceArtifact[] = @java:Method {
    'class: "io.ballerina.wso2.apim.catalog.ServiceCatalog"
} external;
