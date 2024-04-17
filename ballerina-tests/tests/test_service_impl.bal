import ballerina/http;
import ballerina/io;
import ballerina/log;

string artifactFilename = string `${artifactPath}/artifacts.json`;

service / on new http:Listener(8083) {
    json[] artifacts = [];
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8083");
    }
    
    resource function post services(ServiceSchema artifact) returns Service|error? {
        self.artifacts.push(artifact.toJson());
        check io:fileWriteJson(artifactFilename, self.artifacts);

        // return a dummy Service object
        return {
            serviceUrl: "",
            version: "0.1.0",
            definitionType: "OAS3",
            name: "Name"
        };
    }
}