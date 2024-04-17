package io.ballerina.wso2.apim.catalog.utils;

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.swagger.parser.OpenAPIParser;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.parser.core.models.ParseOptions;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import static io.ballerina.wso2.apim.catalog.utils.Constants.AUTH;
import static io.ballerina.wso2.apim.catalog.utils.Constants.BASIC;
import static io.ballerina.wso2.apim.catalog.utils.Constants.COLON;
import static io.ballerina.wso2.apim.catalog.utils.Constants.COMPLETE_MODULE_NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.HOST;
import static io.ballerina.wso2.apim.catalog.utils.Constants.HTTP_ANNOTATION_NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.HTTP_MODULE_NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.JWT_AUTH;
import static io.ballerina.wso2.apim.catalog.utils.Constants.LOCALHOST;
import static io.ballerina.wso2.apim.catalog.utils.Constants.MD5_ALGO_NAME;
import static io.ballerina.wso2.apim.catalog.utils.Constants.NONE;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OAS3;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OAUTH2;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OAUTH2_AUTH;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OPENAPI_DEFINITION;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SERVICE_CATALOG_METADATA_ANNOTATION_IDENTIFIER;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SLASH;
import static io.ballerina.wso2.apim.catalog.utils.Constants.UTF8;

public class Utils {
    private static SecureRandom random = new SecureRandom();

    public static String createMd5Hash(String string) {
        try {
            byte[] bytesOfMessage = string.getBytes(UTF8);
            MessageDigest md = MessageDigest.getInstance(MD5_ALGO_NAME);
            return new String(md.digest(bytesOfMessage), StandardCharsets.UTF_8);
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    public static String getSecurityType(BMap<BString, Object> httpAnnotation) {
        if (httpAnnotation.containsKey(StringUtils.fromString(AUTH))) {
            BArray authArray = httpAnnotation.getArrayValue(StringUtils.fromString(AUTH));
            for (Object authObject: authArray.getValues()) {
                BMap<BString, Object> auth = (BMap<BString, Object>) authObject;
                if (auth.containsKey(StringUtils.fromString(OAUTH2_AUTH))
                        || auth.containsKey(StringUtils.fromString(JWT_AUTH))) {
                    return OAUTH2;
                }
            }
            return BASIC;
        }
        return NONE;
    }

    public static String getDefinitionType() {
        return OAS3;
    }

    public static String getHostname(BMap<BString, Object> annotation) {
        if (annotation == null || !annotation.containsKey(StringUtils.fromString(HOST))) {
            return LOCALHOST;
        }
        return StringUtils.getStringValue(annotation.get(StringUtils.fromString(HOST)));
    }

    public static OpenAPI getOpenApiDefinition(BMap<BString, Object> annotation) {

        BArray openApiDef = (BArray) annotation.get(StringUtils.fromString(OPENAPI_DEFINITION));
        byte[] openApiDefByteStream = openApiDef.getByteArray();
        String string = new String(openApiDefByteStream, StandardCharsets.UTF_8);
        ParseOptions parseOptions = new ParseOptions();
        parseOptions.setResolve(true);
        parseOptions.setResolveFully(true);
        return new OpenAPIParser().readContents(string, null, parseOptions).getOpenAPI();
    }

    public static String generateBasePath(String[] attachPoints) {
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

    public static BMap<BString, Object> getModuleAnnotation(BMap<BString, Object> annotations) {
        if (annotations != null) {
            for (BString key : annotations.getKeys()) {
                String[] annotNames = StringUtils.getStringValue(key).split(COLON);
                if (annotNames[0].equals(COMPLETE_MODULE_NAME) &&
                        annotNames[annotNames.length - 1].equals(SERVICE_CATALOG_METADATA_ANNOTATION_IDENTIFIER)) {
                    return (BMap<BString, Object>) annotations.get(key);
                }
            }
        }
        return null;
    }

    public static String generateRandomHash(int length) {
        byte[] bytes = new byte[length];
        random.nextBytes(bytes);
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X", b)); // Convert each byte to hex string
        }
        return sb.toString();
    }

    public static BMap<BString, Object> getHttpAnnotation(BMap<BString, Object> annotations) {
        if (annotations != null) {
            for (BString key : annotations.getKeys()) {
                String[] annotNames = StringUtils.getStringValue(key).split(COLON);
                if (annotNames[0].equals(HTTP_MODULE_NAME) &&
                        annotNames[annotNames.length - 1].equals(HTTP_ANNOTATION_NAME)) {
                    return (BMap<BString, Object>) annotations.get(key);
                }
            }
        }
        return null;
    }
}
