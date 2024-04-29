import ballerina/os;
import ballerina/log;
import ballerina/mime;
import ballerina/http;
import ballerina/file;

string sep = file:pathSeparator;
string currentDir = file:getCurrentDir();
string rootDir = check file:parentPath(currentDir);
string ballerinaTestDir = string `${rootDir}${sep}ballerina-tests${sep}tests`;
string bal = string `${rootDir}${sep}target${sep}ballerina-runtime${sep}bin${sep}bal`;

function runOSCommand(string projName, string projPath, string configFilePath) returns error? {
    os:Process|os:Error process = os:exec({
            value: string `${bal}`, 
            arguments: ["run", string `${projPath}`]
        }, 
        BAL_CONFIG_FILES = configFilePath
    );

    if process is error {
        log:printInfo(
            string `Error while exec run command in :- ${projName}, e = ${process.message()}`);
        return process;
    }

    int|os:Error waitForExit = process.waitForExit();

    if waitForExit is os:Error {
        // expected behaviour in the tests.
    }
}

function getProjName(int i) returns string {
    return string `test_sample_${i}`;
}

function getProjPath(int i) returns string {
    return string `${rootDir}${sep}test-resources${sep}sample_project_${i}`;
}

function getConfigFilePath(int i) returns string {
    return string `${currentDir}${sep}tests${sep}configs${sep}sample_project_${i}${sep}Config.toml`;
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
