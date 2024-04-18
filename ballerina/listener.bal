import ballerina/io;

public class Listener {
    int port;
    public function 'start() returns error? {
        check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/serviceUrl", serviceUrl);
        ServiceArtifact[] artifacts = getArtifacts();

        check io:fileWriteJson("/Users/admin/Desktop/Test-Codes/fork-Repos/wso2.apim.catalog/ballerina-tests/tests/trash/aftergetartifacts", artifacts.toJson());
        check publishArtifacts(artifacts);
    }

    public function gracefulStop() returns error? {
    }

    public function immediateStop() returns error? {
    }

    public function detach(service object {} s) returns error? {
    }

    public function attach(service object {} s, string[]? name = ()) returns error? {
    }

    public function init(int port) {
        self.port = port;
    }
}
