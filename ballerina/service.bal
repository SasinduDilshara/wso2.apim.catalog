import ballerina/http;
import ballerina/jballerina.java;
import ballerina/oauth2 as _;
import ballerina/log;
import ballerina/io;

configurable string serviceUrl = "https://apis.wso2.com/api/service-catalog/v1";
configurable string user = "?";
configurable string password = "?";
configurable string clientId = "?";
configurable string clientSecret = "?";
configurable string tokenUrl = "https://localhost:9443/oauth2/token";
configurable int port = 5050;
configurable string clientSecureSocketpath = "";
configurable string clientSecureSocketpassword = "";

listener Listener 'listener = new Listener(port);

service / on 'listener {

}

function publishArtifacts(ServiceArtifact[] artifacts) returns error? {
    final Client apimClient = check new (serviceUrl = serviceUrl, config = {
            auth: {username: user, password, clientId, clientSecret, tokenUrl, clientConfig: {
                secureSocket: {cert: {path: clientSecureSocketpath, password: clientSecureSocketpassword}}}}
            });
    // final http:Client apimClient = check new (serviceUrl);

    check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/pubstart", artifacts.toJson());
    boolean errorFound = false;
    error? e = null;

    foreach ServiceArtifact artifact in artifacts {
        string name = artifact.name;
        string definitionFileContent = artifact.definitionFileContent;

        Service|error res = apimClient->/services.post({
            serviceMetadata: {
                name,
                description: artifact.description,
                'version: artifact.version,
                serviceKey: artifact.serviceKey,
                serviceUrl: artifact.serviceUrl,
                definitionType: artifact.definitionType,
                securityType: artifact.securityType,
                mutualSSLEnabled: artifact.mutualSSLEnabled,
                md5: artifact.md5,
                definitionUrl: artifact.definitionUrl
            },
            definitionFile: {fileContent: definitionFileContent.toBytes(), fileName: name},
            inlineContent: definitionFileContent
        });

        // If there is an error, wait until other artifacts get published
        if !errorFound && res is error {
            e = res;
            errorFound = true;
        }
    }

    if errorFound {
        log:printError("Error found while publishing artifacts: ", e);
        if e is http:ApplicationResponseError {
            check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/puberror1", (<error> e).detail().toString());
        } else {
            check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/puberror2", (<error> e).message());
        }
        return e;
    }

    check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/pubsuccess", artifacts.toJson());
}

isolated function getArtifacts() returns ServiceArtifact[] = @java:Method {
    'class: "io.ballerina.wso2.apim.catalog.ServiceCatalog"
} external;
