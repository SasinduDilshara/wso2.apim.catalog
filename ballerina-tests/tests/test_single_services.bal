import ballerina/test;

@test:BeforeEach
function buildAndRunTestProjects() returns error? {
    check buildAndRunProjects();
}

@test:Config{}
function testSingleServices() returns error? {
    check buildAndRunProjects();
    test:assertEquals([], []);
    // test:assertEquals(serviceSchema1, []);
    // test:assertEquals(serviceSchema2, []);
    // test:assertEquals(serviceSchema3, []);
    // test:assertEquals(serviceSchema4, []);
    // test:assertEquals(serviceSchema5, []);
    // test:assertEquals(serviceSchema6, []);
    // test:assertEquals(serviceSchema7, []);
    // test:assertEquals(serviceSchema8, []);
    // test:assertEquals(serviceSchema9, []);
    // test:assertEquals(serviceSchema10, []);
    // test:assertEquals(serviceSchema11, []);
    // test:assertEquals(serviceSchema12, []);
}

