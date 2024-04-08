package io.ballerina.wso2.apim.catalog;

import io.ballerina.runtime.api.Artifact;
import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.wso2.apim.catalog.utils.Constants;
import io.swagger.v3.core.util.Yaml;
import io.swagger.v3.oas.models.OpenAPI;

import java.util.ArrayList;
import java.util.HashMap;

import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.createMd5Hash;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.generateBasePath;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.generateRandomHash;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getDefinitionType;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getHostname;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getHttpAnnotation;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getModuleAnnotation;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getOpenApiDefinition;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getSecurityType;
import static io.ballerina.wso2.apim.catalog.utils.Constants.COLON;
import static io.ballerina.wso2.apim.catalog.utils.Constants.CONFIG;
import static io.ballerina.wso2.apim.catalog.utils.Constants.DEFINITION_TYPE;
import static io.ballerina.wso2.apim.catalog.utils.Constants.DEFINITION_URL;
import static io.ballerina.wso2.apim.catalog.utils.Constants.DESCRIPTION;
import static io.ballerina.wso2.apim.catalog.utils.Constants.LOCALHOST;
import static io.ballerina.wso2.apim.catalog.utils.Constants.MD5;
import static io.ballerina.wso2.apim.catalog.utils.Constants.MUTUAL_SSL;
import static io.ballerina.wso2.apim.catalog.utils.Constants.MUTUAL_SSL_ENABLED;
import static io.ballerina.wso2.apim.catalog.utils.Constants.NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.NONE;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OPENAPI_DEFINITION;
import static io.ballerina.wso2.apim.catalog.utils.Constants.PORT;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SECURE_SOCKET;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SECURITY_TYPE;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SEED;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SERVICE_KEY;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SERVICE_URL;
import static io.ballerina.wso2.apim.catalog.utils.Constants.VERSION;

public class ServiceCatalog {

    public static BArray getArtifacts(Environment env) {
        RecordType recordType = TypeCreator.createRecordType(Constants.SERVICE_ARTIFACT_TYPE_NAME,
                env.getCurrentModule(), 0, false, 0);
        ArrayType arrayType = TypeCreator.createArrayType(recordType);
        BArray arrayValue = ValueCreator.createArrayValue(arrayType);

        for (Artifact artifact : env.getRepository().getArtifacts()) {
            BMap<BString, Object> artifactValues = ValueCreator.createRecordValue(recordType);
            Object listenerDetails = artifact.getDetail(Constants.LISTENERS);
            Object annotationDetails = artifact.getDetail(Constants.ANNOTATIONS);
            Object attachPointDetails = artifact.getDetail(Constants.ATTACH_POINT);

            updateMetadata(env, artifactValues, listenerDetails, annotationDetails, attachPointDetails);
            arrayValue.append(artifactValues);
        }
        return arrayValue;
    }

    private static void updateMetadata(Environment env, BMap<BString, Object> artifactValues, Object listenerDetails,
                                     Object annotationDetails, Object attachPointDetails) {
        BMap<BString, Object> httpAnnotation = getHttpAnnotation((BMap<BString, Object>) annotationDetails);
        HttpServiceConfig httpServiceConfig = updateHostAndPortAndBasePath(listenerDetails,
                attachPointDetails, httpAnnotation);
        updateServiceNameAndUrl(artifactValues, httpServiceConfig);
        updateAnnotationsArtifactValues(artifactValues, annotationDetails, httpAnnotation, env);
        updateListenerConfigurations(artifactValues, listenerDetails);
        updateMd5(artifactValues);
    }

    private static void updateMd5(BMap<BString, Object> artifactValues) {
        String name = StringUtils.getStringValue(artifactValues.get(StringUtils.fromString(NAME)));
        String version = StringUtils.getStringValue(artifactValues.get(StringUtils.fromString(VERSION)));
        String definitionType = StringUtils.getStringValue(artifactValues.get(StringUtils.fromString(DEFINITION_TYPE)));
        String openapiDef = StringUtils.getStringValue(artifactValues.get(StringUtils.fromString(OPENAPI_DEFINITION)));

        String string = new StringBuilder(name).append(version).append(definitionType).append(openapiDef).toString();
        artifactValues.put(StringUtils.fromString(MD5), StringUtils.fromString(createMd5Hash(string)));
    }


    private static void updateServiceNameAndUrl(BMap<BString, Object> artifactValues,
                                                HttpServiceConfig httpServiceConfig) {
        updateServiceName(artifactValues, httpServiceConfig);
        updateServiceUrl(artifactValues, httpServiceConfig);
    }

    private static void updateListenerConfigurations(BMap<BString, Object> artifactValues, Object listenerDetails) {
        artifactValues.put(StringUtils.fromString(MUTUAL_SSL_ENABLED), getMutualSSLDetails(listenerDetails));
    }


    private static boolean getMutualSSLDetails(Object listenerDetails) {
        ArrayList<BObject> listenerArray = (ArrayList<BObject>) listenerDetails;
        if (listenerArray.size() > 0) {
            BObject listener = listenerArray.get(0);
            if (listener != null) {
                Object configObject = listener.getNativeData(CONFIG);
                if (configObject instanceof HashMap) {
                    HashMap<BString, BString> config = (HashMap<BString, BString>) configObject;
                    if (config.containsKey(StringUtils.fromString(SECURE_SOCKET))) {
                        Object secureSocketObject = config.get(StringUtils.fromString(SECURE_SOCKET));
                        if (secureSocketObject instanceof HashMap) {
                            HashMap<BString, BString> secureSocket =
                                    (HashMap<BString, BString>) secureSocketObject;
                            if (secureSocket.containsKey(StringUtils.fromString(MUTUAL_SSL))) {
                                return true;
                            }
                        }
                    }
                }
            }
        }
        return false;
    }

    private static void updateServiceName(BMap<BString, Object> artifactValues, HttpServiceConfig httpServiceConfig) {
        artifactValues.put(StringUtils.fromString(NAME),
                StringUtils.fromString(new StringBuilder()
                        .append(httpServiceConfig.basePath).append(generateRandomHash(SEED)).toString()));
    }

    private static void updateServiceUrl(BMap<BString, Object> artifactValues, HttpServiceConfig httpServiceConfig) {
        String basePath = httpServiceConfig.basePath.equals(LOCALHOST) ? "" : httpServiceConfig.basePath;
        artifactValues.put(StringUtils.fromString(SERVICE_URL),
                new StringBuilder().append(httpServiceConfig.host).
                        append(COLON).append(httpServiceConfig.port).append(basePath).toString());
        artifactValues.put(StringUtils.fromString(DEFINITION_URL),
                new StringBuilder().append(httpServiceConfig.host).
                        append(COLON).append(httpServiceConfig.port).append(basePath).toString());
    }

    private static HttpServiceConfig updateHostAndPortAndBasePath(Object listenerDetails, Object attachPointDetails,
                                                                  BMap<BString, Object> httpAnnotation) {
        BArray attachPoints = (BArray) attachPointDetails;

        String basePath = generateBasePath(attachPoints.getStringArray());
        String port = getPortValue(listenerDetails);
        String host = getHostname(httpAnnotation);
        return new HttpServiceConfig(host, port, basePath);
    }

    private static String getPortValue(Object listenerDetails) {
        ArrayList<BObject> listenerArray = (ArrayList<BObject>) listenerDetails;
        return listenerArray.get(0).get(StringUtils.fromString(PORT)).toString();
    }

    private static void updateAnnotationsArtifactValues(BMap<BString, Object> artifactValues,
                                                        Object annotationDetail, BMap<BString, Object> httpAnnotation,
                                                        Environment env) {
        BMap<BString, Object> annotations = (BMap<BString, Object>) annotationDetail;
        BMap<BString, Object> moduleAnnotation = getModuleAnnotation(annotations);

        if (moduleAnnotation != null) {
            updateModuleAnnotationDetails(moduleAnnotation, artifactValues);
        } else {
            artifactValues.put(StringUtils.fromString(VERSION), StringUtils
                    .fromString(env.getCurrentModule().getMajorVersion()));
        }

        if (httpAnnotation != null) {
            artifactValues.put(StringUtils.fromString(SECURITY_TYPE),
                    StringUtils.fromString(getSecurityType(httpAnnotation)));
        } else {
            artifactValues.put(StringUtils.fromString(SECURITY_TYPE), StringUtils.fromString(NONE));
        }
        artifactValues.put(StringUtils.fromString(DEFINITION_TYPE), StringUtils.fromString(getDefinitionType()));
    }

    private static void updateModuleAnnotationDetails(BMap<BString, Object> moduleAnnotation,
                                                      BMap<BString, Object> artifactValues) {
        OpenAPI openApiDef = getOpenApiDefinition(moduleAnnotation);
        String openApiDefVersion = openApiDef.getInfo().getVersion();

        artifactValues.put(StringUtils.fromString(OPENAPI_DEFINITION),
                StringUtils.fromString(Yaml.pretty(openApiDef)));
        artifactValues.put(StringUtils.fromString(VERSION),
                StringUtils.fromString(openApiDefVersion));
        artifactValues.put(StringUtils.fromString(DESCRIPTION),
                StringUtils.fromString(openApiDef.getInfo().getDescription()));
        artifactValues.put(StringUtils.fromString(SERVICE_KEY),
                StringUtils.fromString(openApiDef.getInfo().getTitle() + COLON + openApiDefVersion));
    }

    static class HttpServiceConfig {
        String host;
        String port;
        String basePath;

        HttpServiceConfig(String host, String port, String basePath) {
            this.host = host;
            this.port = port;
            this.basePath = basePath;
        }
    }
}
