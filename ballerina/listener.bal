public class Listener {
    int port;
    public function 'start() returns error? {
        ServiceArtifact[] artifacts = getArtifacts();
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
