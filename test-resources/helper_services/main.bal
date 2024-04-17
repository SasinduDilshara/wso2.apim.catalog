import ballerina/http;
import ballerina/io;
import ballerina/time;
import ballerina/file;

string currentDir = file:getCurrentDir();
string ballerinaTestDir = string `${check file:parentPath(currentDir)}/ballerina-tests/tests`;
string artifactPath = string `${ballerinaTestDir}/generated_artifacts`;
string artifactFilename = string `${artifactPath}/artifacts.json`;

service / on new http:Listener(8080) {
    json[] artifacts = [];
    
    function init() returns error? {
        json aaa = time:utcToCivil(time:utcNow()).toJson();
        io:Error? fileWriteString = io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/i3.json", aaa);
        fileWriteString = io:fileWriteString("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/i4.txt", ballerinaTestDir);
    }
    
    resource function post services(ServiceSchema artifact) returns Service|error? {
        json aaa = time:utcToCivil(time:utcNow()).toJson();
        io:Error? fileWriteString = io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/i1.json", aaa);
        self.artifacts.push(artifact.toJson());
        check io:fileWriteJson(artifactFilename, self.artifacts);
        return {
            serviceUrl: "",
            version: "0.1.0",
            definitionType: "OAS3",
            name: "Name"
        };
    }
}