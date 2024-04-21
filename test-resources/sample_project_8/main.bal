import ballerina/http;
import ballerinax/wso2.apim.catalog as _;
import ballerina/file;

string ballerinaTestDirPath = file:getCurrentDir();
string resourcesPath = string `${check file:parentPath(ballerinaTestDirPath)}/test-resources/sample_project_8/resources`;
string clientStorepath = string `${resourcesPath}/clientKeyStore.p12`;
string clientStorePassword = "password";
string clientTrustStorePath = string `${resourcesPath}/clientTrustStore.p12`;
string clientTrustStorePassword = "password";

listener http:Listener l = check new (9080, {
    secureSocket: {
        key: {
            path: clientStorepath,
            password: clientStorePassword
        }, 
        mutualSsl: {
            cert: {
                    path: clientTrustStorePath,
                    password: clientTrustStorePassword
            }
        }
    }
});

listener http:Listener l2 = check new (9081, {
    secureSocket: {
        key: {
            path: clientStorepath,
            password: clientStorePassword
        }, 
        mutualSsl: {
            verifyClient: "OPTIONAL",
            cert: {
                path: clientTrustStorePath,
                password: clientTrustStorePassword
            }
        }
    }
});

listener http:Listener l3 = check new (9082, {
    secureSocket: {
        key: {
             path: clientStorepath,
            password: clientStorePassword
        }, 
        mutualSsl: {
            verifyClient: "REQUIRE",
            cert: {
                path: clientTrustStorePath,
                password: clientTrustStorePassword
            }
        }
    }
});

@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
service /sales0 on l {

}

@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
service /sales0 on l2 {

}

@http:ServiceConfig {
    auth: [],
    host: "www.example.com"
}
service /sales0 on l3 {

}
