import ballerina/test;

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
