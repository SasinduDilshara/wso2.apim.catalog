import ballerina/os;
import ballerina/file;
import ballerina/io;
import ballerina/time;
// import test/helper_services as _;

int[] servicePorts = [8080,8081, 8082, 8083, 8084, 8085, 8086, 8087, 8088, 8089, 8090, 8091, 8092, 8093, 8094];

string testResourceDir =  string `${check file:parentPath(file:getCurrentDir())}/test-resources`;
string servicePath = string `${testResourceDir}/helper_services`;

string ballerinaDir =  string `${check file:parentPath(file:getCurrentDir())}/ballerina`;
string bal = "/Users/admin/Desktop/ballerina-lang-clone/ballerina-lang/distribution/zip/jballerina-tools/build/extracted-distributions/jballerina-tools-2201.9.0-SNAPSHOT/bin/bal";

string currentDir = file:getCurrentDir();
string ballerinaTestDir = string `${check file:parentPath(currentDir)}/ballerina-tests/tests`;
string artifactPath = string `${ballerinaTestDir}/generated_artifacts`;

function buildAndRunProjects() returns error? {
    if file:readDir(artifactPath) is error {
        check file:createDir(artifactPath);
    }

    foreach int i in 0...1 {
        json aaa = time:utcToCivil(time:utcNow()).toJson();
        io:Error? fileWriteString = io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/i2.json", aaa);
        fileWriteString = io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/i2.txt", testResourceDir+ " " + artifactPath + " " + servicePath);
        os:Process process = check os:exec({value: string `${bal}`, arguments: ["run", string `${testResourceDir}/sample_project_${i}`]});
        int a = 1;
    }
}

function generateServiceUrl(int index) returns string {
    return string `http:localhost:${servicePorts[index]}`;
}
