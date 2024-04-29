import ballerina/http;
import ballerina/jballerina.java;
import ballerina/oauth2 as _;
import ballerina/oauth2;

configurable string serviceUrl = "https://apis.wso2.com/api/service-catalog/v1";
configurable string username = "";
configurable string password = "";
configurable string? clientId = ();
configurable string? clientSecret = ();
configurable string tokenUrl = "https://localhost:9443/oauth2/token";
configurable int port = 5050;
configurable string clientSecureSocketpath = "";
configurable string clientSecureSocketpassword = "";
configurable string serverCert = "";
configurable string[] scopes = ["service_catalog:service_view", "apim:api_view", "service_catalog:service_write"];

listener Listener 'listener = new Listener(port);

service / on 'listener {

}

function publishArtifacts(ServiceArtifact[] artifacts) returns error? {
    Client apimClient = check new (serviceUrl = serviceUrl, config = {
        auth: {
            username,
            password,
            clientId,
            clientSecret,
            scopes,
            clientConfig: getClientConfig(clientSecureSocketpath, clientSecureSocketpassword)
        },
        secureSocket: getServerCert(serverCert)
    });

    boolean errorFound = false;
    error? e = null;

    foreach ServiceArtifact artifact in artifacts {
        string name = artifact.name;
        string definitionFileContent = artifact.definitionFileContent;

        Service|error res = apimClient->/services.post({
            serviceMetadata: {
                name,
                description: artifact.description,
                'version: artifact.version,
                serviceKey: artifact.serviceKey,
                serviceUrl: artifact.serviceUrl,
                definitionType: artifact.definitionType,
                securityType: artifact.securityType,
                mutualSSLEnabled: artifact.mutualSSLEnabled,
                definitionUrl: artifact.definitionUrl
            },
            inlineContent: definitionFileContent
        });

        // If there is an error, wait until other artifacts get published
        if !errorFound && res is error {
            e = res;
            errorFound = true;
        }
    }

    if errorFound {
        return e;
    }
}

isolated function getArtifacts() returns ServiceArtifact[] = @java:Method {
    'class: "io.ballerina.wso2.apim.catalog.ServiceCatalog"
} external;

function getClientConfig(string clientSecureSocketpath, string clientSecureSocketpassword)
        returns oauth2:ClientConfiguration {
    if clientSecureSocketpath == "" || clientSecureSocketpassword == "" {
        return {secureSocket: {disable: true}};
    }
    return {secureSocket: {cert: {path: clientSecureSocketpath, password: clientSecureSocketpassword}}};
}

function getServerCert(string serverCert) returns http:ClientSecureSocket? {
    if serverCert != "" {
        return {cert: serverCert};
    }
    return {enable: false};
}
