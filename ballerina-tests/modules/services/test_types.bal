import ballerina/constraint;

public type ServiceSchema record {
    Service serviceMetadata;
    record {byte[] fileContent; string fileName;} definitionFile?;
    # Inline content of the document
    string inlineContent?;
};

public type Service record {
    string id?;
    @constraint:String {maxLength: 255, minLength: 1, pattern: re `^[^\*]+$`}
    string name;
    @constraint:String {maxLength: 1024}
    string description?;
    @constraint:String {maxLength: 30, minLength: 1}
    string version;
    @constraint:String {maxLength: 512}
    string serviceKey?;
    string serviceUrl;
    # The type of the provided API definition
    "OAS2"|"OAS3"|"WSDL1"|"WSDL2"|"GRAPHQL_SDL"|"ASYNC_API" definitionType;
    # The security type of the endpoint
    "BASIC"|"DIGEST"|"OAUTH2"|"X509"|"API_KEY"|"NONE" securityType = "NONE";
    # Whether Mutual SSL is enabled for the endpoint
    boolean mutualSSLEnabled = false;
    # Number of usages of the service in APIs
    int usage?;
    string createdTime?;
    string lastUpdatedTime?;
    string md5?;
    string definitionUrl?;
};
