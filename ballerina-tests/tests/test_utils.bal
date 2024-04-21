import ballerina/os;
import ballerina/file;
import ballerina/log;
import ballerina/io;
import ballerina/http;
import ballerina/mime;

const numOftestSources = 9;

string testResourceDir =  string `${check file:parentPath(file:getCurrentDir())}/test-resources`;
string bal = "/Users/admin/Desktop/ballerina-lang-clone/ballerina-lang/distribution/zip/jballerina-tools/build/extracted-distributions/jballerina-tools-2201.9.0-SNAPSHOT/bin/bal";

string currentDir = file:getCurrentDir();
string ballerinaTestDir = string `${check file:parentPath(currentDir)}/ballerina-tests/tests`;
string artifactPath = string `${ballerinaTestDir}/generated_artifacts`;
string configsPath = string `${currentDir}/tests/configs`;
string runConfigsPath = string `${configsPath}/run-configs`;
string trustStorePath = string `${currentDir}/tests/resources/ballerinaTruststore.p12`;
string trustStoreConfig = string `clientSecureSocketpath="${trustStorePath}"`;

function buildAndRunProjects() returns error? {
    if file:readDir(artifactPath) !is error {
        check file:remove(artifactPath, file:RECURSIVE);
    }
    check file:createDir(artifactPath);

    foreach int i in 0...numOftestSources {
        string projName = string `sample_project_${i}`;
        string runConfigFile = string `${runConfigsPath}/${projName}/Config.toml`;
        string|error runConfigurations = getConfigurations(runConfigFile);
        if runConfigurations is error {
            log:printInfo(string `Error while updating run-configs in :- ${projName}, e = ${runConfigurations.message()}`);
            continue;
        }

        string configFile = string `${configsPath}/${projName}/Config.toml`;
        error? updatedRunConfigurations = updateConfigurations(configFile, runConfigurations);
         if updatedRunConfigurations is error {
            log:printInfo(
                string `Error while getting configs in :- ${projName}, e = ${updatedRunConfigurations.message()}`);
            continue;
        }

        string|error configurations = getConfigurations(configFile);
        if configurations is error {
            log:printInfo(string `Error while getting configs in :- ${projName}, e = ${configurations.message()}`);
            continue;
        }

        log:printInfo(string `Updating configs in :- ${projName}`);
        error? trustStoreConfigResult = updateTrustStoreConfig(configFile, configurations);
        if trustStoreConfigResult is error {
            log:printInfo(
                string `Error while getting configs in :- ${projName}, e = ${trustStoreConfigResult.message()}`);
            continue;
        }

        log:printInfo(string `Running Ballerina project:- ${projName}`);
        os:Process|os:Error process = os:exec({value: string `${bal}`, 
                    arguments: ["run", string `${testResourceDir}/${projName}`]}, 
                    BAL_CONFIG_FILES = configFile);
        if process is error {
            log:printInfo(
                string `Error while exec run command in :- ${projName}, e = ${process.message()}`);
            continue;
        }

        log:printInfo(string `Waiting for process exit in :- ${projName}`);
        int|os:Error waitForExit = process.waitForExit();
        byte[]|error output = process.output();
        if output is error {
            log:printInfo(
                string `Error while getting the output of the os process in :- ${projName}, e = ${output.message()}`);
        } else {
            log:printInfo(string `Execution results of :- ${projName} - ${check string:fromBytes(output)}}`);
        }

        if waitForExit is os:Error {
            log:printInfo(string `Error while running :- ${projName}, e = ${waitForExit.message()}`);
        } else {
            log:printInfo(string `Execution of :- ${projName} ends with exit code - ${waitForExit}}`);
        }

        log:printInfo(string `Reverting configs in :- ${projName}`);
        error? configurationsResult = updateConfigurations(configFile, configurations);
        if configurationsResult is error {
            log:printInfo(
                string `Error while getting configs in :- ${projName}, e = ${configurationsResult.message()}`);
            continue;
        }

        log:printInfo(string `Finished tasks in :- ${projName}`);
    }
}

function updateTrustStoreConfig(string configFile, string configurations) returns error? {
    string newConfigs = string `${configurations}${io:NEW_LINE}${trustStoreConfig}`;
    check updateConfigurations(configFile, newConfigs);
}

function updateConfigurations(string configFile, string newConfigs) returns error? {
    check io:fileWriteString(configFile, newConfigs, io:OVERWRITE);
}

function getConfigurations(string configFile) returns string|error {
    return check io:fileReadString(configFile);
}

function traverseMultiPartRequest(http:Request req) returns ServiceSchema|error {
    mime:Entity[] bodyParts = check req.getBodyParts();
    Service serviceMetadata = check (check bodyParts[0].getJson()).cloneWithType();
    byte[] fileContent = check bodyParts[1].getByteArray();
    string inlineContent = check bodyParts[2].getText();

    return {
        serviceMetadata,
        definitionFile: {fileContent, fileName: serviceMetadata.name},
        inlineContent
    };
}

function returnDummyResponse() returns json {
    return {
        serviceUrl: "",
        version: "0.1.0",
        definitionType: "OAS3",
        name: "Name"
    };
}
