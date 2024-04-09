import ballerina/os;
import ballerina/file;

string testResourceDir =  string `${check file:parentPath(file:getCurrentDir())}/test_resources`;
string ballerinaDir =  string `${check file:parentPath(file:getCurrentDir())}/ballerina`;
string bal = "/Users/admin/Desktop/ballerina-lang-clone/hinduja-ballerina-lang/ballerina-lang/distribution/zip/jballerina-tools/build/extracted-distributions/jballerina-tools-2201.9.0-SNAPSHOT/bin/bal";

function buildAndRunProjects() returns error? {
    _ = check os:exec({value: "cd", arguments: [string `${ballerinaDir}`]});
    _ = check os:exec({value: string `${bal}`, arguments: ["pack"]});
    _ = check os:exec({value: string `${bal}`, arguments: ["push--repository=local"]});
    foreach int i in 0...1 {
        _ = check os:exec({value: string `${bal}`, arguments: ["run", string `${testResourceDir}/sample_project_${i}`]});
    }
}

function initiateServices() {

}