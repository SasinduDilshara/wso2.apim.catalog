import ballerina/file;
import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/mime;
import ballerina/os;

const numOftestSources = 9;

string sep = file:pathSeparator;
string testResourceDir = string `${check file:parentPath(file:getCurrentDir())}${sep}test-resources`;
string currentDir = file:getCurrentDir();
string rootDir = check file:parentPath(currentDir);
string ballerinaTestDir = string `${rootDir}${sep}ballerina-tests${sep}tests`;
string artifactPath = string `${ballerinaTestDir}${sep}generated_artifacts`;
string configsPath = string `${currentDir}${sep}tests${sep}configs`;
string runConfigsPath = string `${configsPath}${sep}run-configs`;
string trustStorePath = string `${currentDir}${sep}tests${sep}resources${sep}ballerinaTruststore.p12`;
string trustStoreConfig = string `clientSecureSocketpath="${trustStorePath}"`;
string bal = string `${rootDir}${sep}target${sep}ballerina-runtime${sep}bin${sep}bal`;

function buildAndRunProjects() returns error? {
    if file:readDir(artifactPath) !is error {
        check file:remove(artifactPath, file:RECURSIVE);
    }
    check file:createDir(artifactPath);

    foreach int i in 0 ... numOftestSources {
        string projName = string `sample_project_${i}`;
        string runConfigFile = string `${runConfigsPath}/${projName}${sep}Config.toml`;
        string|error runConfigurations = getConfigurations(runConfigFile);
        if runConfigurations is error {
            log:printInfo(string `Error while updating run-configs in :- ${projName}, e = ${runConfigurations.message()}`);
            continue;
        }

        string configFile = string `${configsPath}/${projName}${sep}Config.toml`;
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

        error? trustStoreConfigResult = updateTrustStoreConfig(configFile, configurations);
        if trustStoreConfigResult is error {
            log:printInfo(
                string `Error while getting configs in :- ${projName}, e = ${trustStoreConfigResult.message()}`);
            continue;
        }

        log:printInfo(string `Running Ballerina project:- ${projName}`);
        os:Process|os:Error process = os:exec({
            value: string `${bal}`,
            arguments: ["run", string `${testResourceDir}/${projName}`]
        },
                    BAL_CONFIG_FILES = configFile);
        if process is error {
            log:printInfo(
                string `Error while exec run command in :- ${projName}, e = ${process.message()}`);
            continue;
        }

        int|os:Error waitForExit = process.waitForExit();
        byte[]|error output = process.output();
        if output is error {
            log:printInfo(
                string `Error while getting the output of the os process in :- ${projName}, e = ${output.message()}`);
        }

        if waitForExit is os:Error {
            log:printInfo(string `Error while running :- ${projName}, e = ${waitForExit.message()}`);
        }

        error? configurationsResult = updateConfigurations(configFile, configurations);
        if configurationsResult is error {
            log:printInfo(
                string `Error while getting configs in :- ${projName}, e = ${configurationsResult.message()}`);
            continue;
        }
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
