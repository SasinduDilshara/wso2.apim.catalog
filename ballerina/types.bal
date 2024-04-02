//  Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
//
//  WSO2 LLC. licenses this file to you under the Apache License,
//  Version 2.0 (the "License"); you may not use this file except
//  in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied. See the License for the
//  specific language governing permissions and limitations
//  under the License.
//

public annotation ServiceCatalogMetaData ServiceCatalogConfig on service;

public type ServiceCatalogMetaData record {|
    byte[] openApiDefinition = [];
|};

public type ServiceArtifact record {|
    string id;
    string name;
    string description = "";
    string version = "_";
    string serviceKey;
    string serviceUrl;
    string definitionType;
    string securityType = "BASIC";
    boolean mutualSSLEnabled = false;
    int usage = 1;
    string createdTime;
    string lastUpdatedTime;
    string md5;
    string definitionUrl;
|};

