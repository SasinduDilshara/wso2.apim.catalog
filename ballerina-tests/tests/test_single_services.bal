import ballerina/test;
import ballerina/os;
import ballerina/log;
import ballerina/file;

string sep = file:pathSeparator;
string currentDir = file:getCurrentDir();
string rootDir = check file:parentPath(currentDir);
string ballerinaTestDir = string `${rootDir}${sep}ballerina-tests${sep}tests`;
string bal = string `${rootDir}${sep}target${sep}ballerina-runtime${sep}bin${sep}bal`;

@test:Config{}
function testSingleService() returns error? {
    int index = 0;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

@test:Config{}
function testSingleService2() returns error? {
    int index = 1;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

@test:Config{}
function testSingleService3() returns error? {
    int index = 2;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

@test:Config{}
function testSingleService4() returns error? {
    int index = 3;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

@test:Config{}
function testSingleService5() returns error? {
    int index = 4;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

@test:Config{}
function testSingleService6() returns error? {
    int index = 5;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

@test:Config{}
function testSingleService7() returns error? {
    int index = 6;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

@test:Config{}
function testSingleService8() returns error? {
    int index = 7;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

@test:Config{}
function testSingleService9() returns error? {
    int index = 8;
    error? result = runOSCommand(getProjName(index), getProjPath(index), getConfigFilePath(index));
    test:assertTrue(result is (), result is error ? (<error>result).message(): "");
}

function runOSCommand(string projName, string projPath, string configFilePath) returns error? {
    log:printInfo(string `projPath - ${projPath}`);
    log:printInfo(string `configFilePath - ${configFilePath}`);
    log:printInfo(string `Running Ballerina project:- ${projName}`);

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
    return string `${currentDir}${sep}tests${sep}configs${sep}run-configs${sep}sample_project_${i}${sep}Config.toml`;
}
