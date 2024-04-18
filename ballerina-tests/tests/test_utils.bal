import ballerina/os;
import ballerina/file;
import ballerina/log;
import ballerina/io;

string testResourceDir =  string `${check file:parentPath(file:getCurrentDir())}/test-resources`;
string bal = "/Users/admin/Desktop/ballerina-lang-clone/ballerina-lang/distribution/zip/jballerina-tools/build/extracted-distributions/jballerina-tools-2201.9.0-SNAPSHOT/bin/bal";

string currentDir = file:getCurrentDir();
string ballerinaTestDir = string `${check file:parentPath(currentDir)}/ballerina-tests/tests`;
string artifactPath = string `${ballerinaTestDir}/generated_artifacts`;
string configsPath = string `${currentDir}/tests/configs`;
string trustStorePath = string `${currentDir}/tests/resources/ballerinaTruststore.p12`;
string trustStoreConfig = string `clientSecureSocketpath="${trustStorePath}"`;

function buildAndRunProjects() returns error? {
    if file:readDir(artifactPath) is error {
        check file:createDir(artifactPath);
    }

    foreach int i in [0] {
        string projName = string `sample_project_${i}`;
        string configFile = string `${configsPath}/${projName}/Config.toml`;

        log:printInfo(string `Running Ballerina project:- ${projName}`);
        string configurations = check getConfigurations(configFile);
        check updateTrustStoreConfig(configFile, configurations);
        os:Process process = check os:exec({value: string `${bal}`, 
                    arguments: ["run", string `${testResourceDir}/${projName}`]}, 
                    BAL_CONFIG_FILES = configFile);
        _ = check process.waitForExit();
        check updateConfigurations(configFile, configurations);
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
