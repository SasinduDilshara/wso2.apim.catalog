import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/mime;


service / on new http:Listener(8080) {
    json[] artifacts = [];
    string artifactFilename = string `${artifactPath}/artifacts_0.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8080");
    }
    
    resource function post services(http:Request req) returns json|error {
        mime:Entity[] bodyParts = check req.getBodyParts();
        json artifact = check bodyParts[0].getJson();
        self.artifacts.push(artifact.toJson());
        self.artifacts.push(artifact.toJson());
        check io:fileWriteJson(self.artifactFilename, self.artifacts);

        // return a dummy Service object
        return {
            serviceUrl: "",
            version: "0.1.0",
            definitionType: "OAS3",
            name: "Name"
        };
    }
}