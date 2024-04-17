import ballerina/os;
import ballerina/file;
import ballerina/log;
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

    foreach int i in [0] {
        log:printInfo(string `Running Ballerina project:- sample_project_${i}`);
        os:Process process = check os:exec({value: string `${bal}`, arguments: ["run", string `${testResourceDir}/sample_project_${i}`]});
        _ = check process.waitForExit();
    }
}

function generateServiceUrl(int index) returns string {
    return string `http:localhost:${servicePorts[index]}`;
}
