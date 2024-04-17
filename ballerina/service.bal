import ballerina/http;
import ballerina/jballerina.java;
import ballerina/oauth2 as _;
import ballerina/io;

configurable string serviceUrl = "https://apis.wso2.com/api/service-catalog/v1";
configurable string user = "?";
configurable string password = "?";
configurable string clientId = "?";
configurable string clientSecret = "?";
configurable string tokenUrl = "https://localhost:9443/oauth2/token";
configurable int port = 5050;

// final Client apimClient = check new (serviceUrl = serviceUrl, config = {auth: {username: user, password, clientId, clientSecret, tokenUrl}});
http:Client apimClient = check new(serviceUrl);

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
        string definitionFileContent = artifact.definitionFileContent;

        Service|error res = apimClient->/services.post({
            serviceMetadata: {
                name,
                // name: "A",
                description: artifact.description,
                // description: "",
                'version: artifact.version,
                // 'version: "0",
                serviceKey: artifact.serviceKey,
                // serviceKey: "",
                serviceUrl: artifact.serviceUrl,
                // serviceUrl: "",
                definitionType: artifact.definitionType,
                // definitionType: OAS3,
                securityType: artifact.securityType,
                // securityType: BASIC,
                mutualSSLEnabled: artifact.mutualSSLEnabled,
                // mutualSSLEnabled: true,
                md5: artifact.md5,
                // md5: "",
                definitionUrl: artifact.definitionUrl
                // definitionUrl: ""
            },
            definitionFile: {fileContent: definitionFileContent.toBytes(), fileName: name},
            // definitionFile: {fileContent: [], fileName: "name"},
            inlineContent: definitionFileContent
            // inlineContent: ""
        });
        if res is Service { check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test2.json", res.toJson()); }

        // If there is an error, wait until other artifacts get published
        if !errorFound && res is error {
            e = res;
            if e is http:ApplicationResponseError {
                check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test1detail.json", (<error> e).detail().toString());
            }
            errorFound = true;
            check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test1xx.txt", "Found " + (<error> e).message(), io:APPEND);
            return e;
        }
        
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test1.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test2.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test3.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test4.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test5.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test6.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test7.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test8.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test9.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test10.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test11.txt", "1111111", io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test12.txt", "1111111", io:APPEND);
    }

    if errorFound {
        check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test12.txt", (<error> e).message(), io:APPEND);
        // check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/a.txt", (<error> e).message() + "\n" + ((<error> (<error> e).cause()).message()));
        // io:println("\nSTACK_TRACE");
        // (<error> e).stackTrace().forEach(a => io:println(a.toString()));
        // io:println("STACK_TRACE\n");
        return e;
    }
    check io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test12.txt", "NOT END", io:APPEND);
    check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/test3.json", artifacts.toJson());
    check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/test/test/check_start/trash/test4.json", artifacts.toJson());
}

isolated function getArtifacts() returns ServiceArtifact[] = @java:Method {
    'class: "io.ballerina.wso2.apim.catalog.ServiceCatalog"
} external;
