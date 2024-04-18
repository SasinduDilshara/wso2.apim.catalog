import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/mime;

service / on new http:Listener(8080) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_0.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8080");
    }
    
    resource function post services(http:Request req) returns json|error {
        mime:Entity[] bodyParts = check req.getBodyParts();
        Service serviceMetadata = check (check bodyParts[0].getJson()).cloneWithType();
        byte[] fileContent = check bodyParts[1].getByteArray();
        string inlineContent = check bodyParts[2].getText();

        ServiceSchema schema = {
            serviceMetadata,
            definitionFile: {fileContent, fileName: serviceMetadata.name},
            inlineContent
        };
        self.artifacts.push(schema);

        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());

        // return a dummy Service object
        return {
            serviceUrl: "",
            version: "0.1.0",
            definitionType: "OAS3",
            name: "Name"
        };
    }
}