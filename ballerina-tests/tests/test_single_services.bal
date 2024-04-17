import ballerina/test;

@test:BeforeEach
function buildAndRunTestProjects() returns error? {
    check buildAndRunProjects();
}

@test:Config{}
function testSingleServices() returns error? {
    check buildAndRunProjects();
    test:assertEquals([], []);
}
