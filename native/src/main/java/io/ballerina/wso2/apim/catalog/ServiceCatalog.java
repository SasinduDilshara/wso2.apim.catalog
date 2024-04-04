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
import io.swagger.parser.OpenAPIParser;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.parser.core.models.ParseOptions;

import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.ArrayList;

import static io.ballerina.wso2.apim.catalog.utils.Constants.BASIC;
import static io.ballerina.wso2.apim.catalog.utils.Constants.COLON;
import static io.ballerina.wso2.apim.catalog.utils.Constants.COMPLETE_MODULE_NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.DEFINITION_TYPE;
import static io.ballerina.wso2.apim.catalog.utils.Constants.DEFINITION_URL;
import static io.ballerina.wso2.apim.catalog.utils.Constants.DESCRIPTION;
import static io.ballerina.wso2.apim.catalog.utils.Constants.HOST;
import static io.ballerina.wso2.apim.catalog.utils.Constants.HTTP_ANNOTATION_NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.HTTP_MODULE_NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.LOCALHOST;
import static io.ballerina.wso2.apim.catalog.utils.Constants.NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OAS2;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OAS3;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OPENAPI_DEFINITION;
import static io.ballerina.wso2.apim.catalog.utils.Constants.PORT;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SECURITY_TYPE;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SEED;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SERVICE_CATALOG_METADATA_ANNOTATION_IDENTIFIER;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SERVICE_KEY;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SERVICE_URL;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SLASH;
import static io.ballerina.wso2.apim.catalog.utils.Constants.VERSION;

public class ServiceCatalog {

    public static BArray getArtifacts(Environment env) {
        RecordType recordType = TypeCreator.createRecordType(Constants.SERVICE_ARTIFACT_TYPE_NAME,
                env.getCurrentModule(), 0, false, 0);
        ArrayType arrayType = TypeCreator.createArrayType(recordType);
        BArray arrayValue = ValueCreator.createArrayValue(arrayType);

        for (Artifact artifact: env.getRepository().getArtifacts()) {
            Object listenerDetails = artifact.getDetail(Constants.LISTENERS);
            Object annotationDetails = artifact.getDetail(Constants.ANNOTATIONS);
            Object attachPointDetails = artifact.getDetail(Constants.ATTACH_POINT);
            BMap<BString, Object> artifactValues = ValueCreator.createRecordValue(recordType);

            BMap<BString, Object> httpAnnotation = getHttpAnnotation((BMap<BString, Object>) annotationDetails);
            HttpServiceConfig httpServiceConfig = updateHostAndPortAndBasePath(listenerDetails,
                    attachPointDetails, httpAnnotation);
            updateServiceName(artifactValues, httpServiceConfig);
            updateServiceUrl(artifactValues, httpServiceConfig);
            updateAnnotationsArtifactValues(artifactValues, annotationDetails, httpAnnotation, env);
            updateListenerConfigurations(artifactValues, listenerDetails);

            updateDefaultValues(artifactValues);
            arrayValue.append(artifactValues);
        }
        return arrayValue;
    }

    private static void updateListenerConfigurations(BMap<BString, Object> artifactValues, Object listenerDetails) {

    }

    private static void updateServiceName(BMap<BString, Object> artifactValues, HttpServiceConfig httpServiceConfig) {
        artifactValues.put(StringUtils.fromString(NAME),
                StringUtils.fromString(new StringBuilder()
                        .append(httpServiceConfig.basePath).append(generateRandomHash(SEED)).toString()));
    }

    private static void updateServiceUrl(BMap<BString, Object> artifactValues, HttpServiceConfig httpServiceConfig) {
        String basePath = httpServiceConfig.basePath == LOCALHOST ? "" : httpServiceConfig.basePath;
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

    public static Object publishArtifacts(Environment env, BArray artifactValues) {
        for (Object artifactValue: artifactValues.getValues()) {
            Artifact artifact = (Artifact) artifactValue;
            publish(artifact);
        }
        return null;
    }

    private static void publish(Artifact artifact) {

    }

    private static void updateAnnotationsArtifactValues(BMap<BString, Object> artifactValues,
                                                        Object annotationDetail, BMap<BString, Object> httpAnnotation,
                                                        Environment env) {
        BMap<BString, Object> annotations = (BMap<BString, Object>) annotationDetail;
        BMap<BString, Object> moduleAnnotation = getModuleAnnotation(annotations);

        if (moduleAnnotation != null) {
            OpenAPI openApiDef = getOpenApiDefinition(moduleAnnotation);
            String openApiDefVersion = openApiDef.getInfo().getVersion();
            artifactValues.put(StringUtils.fromString(VERSION),
                    StringUtils.fromString(openApiDefVersion));
            artifactValues.put(StringUtils.fromString(DESCRIPTION),
                    StringUtils.fromString(openApiDef.getInfo().getDescription()));
            artifactValues.put(StringUtils.fromString(SERVICE_KEY),
                    StringUtils.fromString(openApiDef.getInfo().getTitle() + COLON + openApiDefVersion));
            artifactValues.put(StringUtils.fromString(DEFINITION_TYPE),
                    StringUtils.fromString(getDefinitionType(openApiDef.getInfo().getVersion())));
        } else {
            artifactValues.put(StringUtils.fromString(VERSION), env.getCurrentModule().getMajorVersion());
            artifactValues.put(StringUtils.fromString(DEFINITION_TYPE), OAS3);
        }

        if (httpAnnotation != null) {
        }
    }

    private static String getDefinitionType(String version) {
        if (version.startsWith("2")) {
            return OAS2;
        }
        return OAS3;
    }

    public static String getHostname(BMap<BString, Object> annotation) {
        if (annotation == null) {
            return LOCALHOST;
        }
        return annotation.get(StringUtils.fromString(HOST)).toString();
    }

    private static OpenAPI getOpenApiDefinition(BMap<BString, Object> annotation) {
        BArray openApiDef = (BArray) annotation.get(StringUtils.fromString(OPENAPI_DEFINITION));
        byte[] openApiDefByteStream = openApiDef.getByteArray();
        String string = new String(openApiDefByteStream, StandardCharsets.UTF_8);
        ParseOptions parseOptions = new ParseOptions();
        parseOptions.setResolve(true);
        parseOptions.setResolveFully(true);
        return new OpenAPIParser().readContents(string, null, parseOptions).getOpenAPI();
    }

    private static void updateDefaultValues(BMap<BString, Object> artifactValues) {
        artifactValues.put(StringUtils.fromString(DEFINITION_TYPE), OAS3);
        artifactValues.put(StringUtils.fromString(SECURITY_TYPE), BASIC);
    }

    private static String generateBasePath(String[] attachPoints) {
        if (attachPoints.length == 0) {
            return SLASH;
        }

        StringBuilder sb = new StringBuilder();
        sb.append(SLASH);
        for (int i = 0, attachPointsLength = attachPoints.length; i < attachPointsLength; i++) {
            sb.append(attachPoints[i]).append(SLASH);
        }
        return sb.substring(0, sb.length() - 1);
    }

    private static BMap<BString, Object> getModuleAnnotation(BMap<BString, Object> annotations) {
        for (BString key: annotations.getKeys()) {
            String[] annotNames = StringUtils.getStringValue(key).split(COLON);
            if (annotNames[0].equals(COMPLETE_MODULE_NAME) &&
                    annotNames[annotNames.length - 1].equals(SERVICE_CATALOG_METADATA_ANNOTATION_IDENTIFIER)) {
                return (BMap<BString, Object>) annotations.get(key);
            }
        }
        return null;
    }

    public static String generateRandomHash(int length) {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[length];
        random.nextBytes(bytes);
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X", b)); // Convert each byte to hex string
        }
        return sb.toString();
    }

    private static BMap<BString, Object> getHttpAnnotation(BMap<BString, Object> annotations) {
        for (BString key: annotations.getKeys()) {
            String[] annotNames = StringUtils.getStringValue(key).split(COLON);
            if (annotNames[0].equals(HTTP_MODULE_NAME) &&
                    annotNames[annotNames.length - 1].equals(HTTP_ANNOTATION_NAME)) {
                return (BMap<BString, Object>) annotations.get(key);
            }
        }
        return null;
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
