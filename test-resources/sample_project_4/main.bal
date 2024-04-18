import ballerina/http;
import ballerinax/wso2.apim.catalog as _;

@http:ServiceConfig {
    auth: (),
    host: "www.example.com"
}
service /sales0 on new http:Listener(9400) {

}

@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
service /sales0/base on new http:Listener(9401) {

}

@http:ServiceConfig {
    auth: [{fileUserStoreConfig: {}}],
    host: "www.example.com"
}
service /sales0 on new http:Listener(9402) {

}

@http:ServiceConfig {
    auth: [
        {
            ldapUserStoreConfig: {
                domainName: "",
                connectionUrl: "",
                connectionName: "",
                connectionPassword: "",
                userSearchBase: "",
                userEntryObjectClass: "",
                userNameAttribute: "",
                userNameSearchFilter: "",
                userNameListFilter: "",
                groupSearchBase: [],
                groupEntryObjectClass: "",
                groupNameAttribute: "",
                groupNameSearchFilter: "",
                groupNameListFilter: "",
                membershipAttribute: ""
            }}],
    host: "www.example.com"
}
service /sales0 on new http:Listener(9403) {

}

@http:ServiceConfig {auth: [{jwtValidatorConfig: {}}]}
service /sales0 on new http:Listener(9404) {

}

@http:ServiceConfig {auth: [{oauth2IntrospectionConfig: {url: ""}}]}
service /sales0 on new http:Listener(9405) {

}
