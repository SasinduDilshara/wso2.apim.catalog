import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/mime;

string artifactPath = string `${ballerinaTestDir}${sep}generated_artifacts`;

service / on new http:Listener(8080) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_0.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8080");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

service / on new http:Listener(8081) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_1.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8081");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

service / on new http:Listener(8082) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_2.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8082");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

service / on new http:Listener(8083) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_3.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8083");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

service / on new http:Listener(8084) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_4.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8084");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

service / on new http:Listener(8085) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_5.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8085");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

service / on new http:Listener(8086) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_6.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8086");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

service / on new http:Listener(8087) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_7.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8087");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

service / on new http:Listener(8088) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}${sep}artifacts_8.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8088");
    }
    
    resource function post services(http:Request req) returns Service|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        return returnDummyResponse();
    }
}

function traverseMultiPartRequest(http:Request req) returns ServiceSchema|error {
    mime:Entity[] bodyParts = check req.getBodyParts();
    Service serviceMetadata = check (check bodyParts[0].getJson()).cloneWithType();
    string inlineContent = check bodyParts[1].getText();
    return {
        serviceMetadata,
        inlineContent
    };
}

function returnDummyResponse() returns error {
    // Return error to terminate the test process
    return error("Successfully processed the request");
}
