import ballerina/http;
import ballerina/io;
import ballerina/log;

service / on new http:Listener(8080) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_0.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8080");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8081) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_1.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8081");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8082) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_2.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8082");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8083) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_3.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8083");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8084) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_4.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8084");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8085) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_5.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8085");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8086) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_6.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8086");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8087) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_7.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8087");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8088) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_8.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8088");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8089) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_9.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8089");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}

service / on new http:Listener(8090) {
    ServiceSchema[] artifacts = [];
    string artifactJsonFilename = string `${artifactPath}/artifacts_0.json`;
    
    function init() returns error? {
        log:printInfo("Starting the test server on port 8090");
    }
    
    resource function post services(http:Request req) returns json|error {
        ServiceSchema schema = check traverseMultiPartRequest(req);
        self.artifacts.push(schema);
        check io:fileWriteJson(self.artifactJsonFilename, self.artifacts.toJson());
        log:printInfo(string `Finished writing artifacts into - ${self.artifactJsonFilename}`);
        return returnDummyResponse();
    }
}
