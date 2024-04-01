package io.ballerina.wso2.apim.catalog.utils;

import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.runtime.api.utils.IdentifierUtils;
import org.apache.commons.io.FilenameUtils;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Locale;
import java.util.Objects;
import java.util.stream.Collectors;

import static io.ballerina.wso2.apim.catalog.utils.Constants.HYPHEN;
import static io.ballerina.wso2.apim.catalog.utils.Constants.JSON_EXTENSION;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OPENAPI_SUFFIX;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SLASH;
import static io.ballerina.wso2.apim.catalog.utils.Constants.UNDERSCORE;
import static io.ballerina.wso2.apim.catalog.utils.Constants.YAML_EXTENSION;

public class CommonUtils {
    public static String unescapeIdentifier(String parameterName) {
        String unescapedParamName = IdentifierUtils.unescapeBallerina(parameterName);
        return unescapedParamName.replaceAll("\\\\", "").replaceAll("'", "");
    }

    public static String getServiceBasePath(ServiceDeclarationNode serviceDefinition) {
        StringBuilder currentServiceName = new StringBuilder();
        NodeList<Node> serviceNameNodes = serviceDefinition.absoluteResourcePath();
        for (Node serviceBasedPathNode : serviceNameNodes) {
            currentServiceName.append(unescapeIdentifier(serviceBasedPathNode.toString()));
        }
        return currentServiceName.toString().trim();
    }

    public static String getOpenApiFileName(String servicePath, String serviceName, boolean isJson) {
        String openAPIFileName;
        if (serviceName.isBlank() || serviceName.equals(SLASH) || serviceName.startsWith(SLASH + HYPHEN)) {
            String[] fileName = serviceName.split(SLASH);
            // This condition is to handle `service on ep1 {} ` multiple scenarios
            if (fileName.length > 0 && !serviceName.isBlank()) {
                openAPIFileName = FilenameUtils.removeExtension(servicePath) + fileName[1];
            } else {
                openAPIFileName = FilenameUtils.removeExtension(servicePath);
            }
        } else if (serviceName.startsWith(HYPHEN)) {
            // serviceName -> service on ep1 {} has multiple service ex: "-33456"
            openAPIFileName = FilenameUtils.removeExtension(servicePath) + serviceName;
        } else {
            // Remove starting path separate if exists
            if (serviceName.startsWith(SLASH)) {
                serviceName = serviceName.substring(1);
            }
            // Replace rest of the path separators with underscore
            openAPIFileName = serviceName.replaceAll(SLASH, "_");
        }

        return getNormalizedFileName(openAPIFileName) + OPENAPI_SUFFIX +
                (isJson ? JSON_EXTENSION : YAML_EXTENSION);
    }

    public static String getNormalizedFileName(String openAPIFileName) {
        String[] splitNames = openAPIFileName.split("[^a-zA-Z0-9]");
        if (splitNames.length > 0) {
            return Arrays.stream(splitNames)
                    .filter(namePart -> !namePart.isBlank())
                    .collect(Collectors.joining(UNDERSCORE));
        }
        return openAPIFileName;
    }

    public static String resolveContractFileName(Path outPath, String openApiName, Boolean isJson) {
        if (outPath != null && Files.exists(outPath)) {
            final File[] listFiles = new File(String.valueOf(outPath)).listFiles();
            if (listFiles != null) {
                openApiName = checkAvailabilityOfGivenName(openApiName, listFiles, isJson);
            }
        }
        return openApiName;
    }

    private static String checkAvailabilityOfGivenName(String openApiName, File[] listFiles, Boolean isJson) {
        for (File file : listFiles) {
            if (System.console() != null && file.getName().equals(openApiName)) {
                String userInput = System.console().readLine("There is already a file named ' " + file.getName() +
                        "' in the target location. Do you want to overwrite the file? [y/N] ");
                if (!Objects.equals(userInput.toLowerCase(Locale.ENGLISH), "y")) {
                    openApiName = setGeneratedFileName(listFiles, openApiName, isJson);
                }
            }
        }
        return openApiName;
    }

    private static String setGeneratedFileName(File[] listFiles, String fileName, boolean isJson) {
        int duplicateCount = 0;
        for (File listFile : listFiles) {
            String listFileName = listFile.getName();
            if (listFileName.contains(".") && ((listFileName.split("\\.")).length >= 2)
                    && (listFileName.split("\\.")[0]
                    .equals(fileName.split("\\.")[0]))) {
                duplicateCount++;
            }
        }
        if (isJson) {
            return fileName.split("\\.")[0] + "." + duplicateCount + JSON_EXTENSION;
        }
        return fileName.split("\\.")[0] + "." + duplicateCount + YAML_EXTENSION;
    }

    public static void writeFile(Path filePath, String content) throws IOException {
        try (FileWriter writer = new FileWriter(filePath.toString(), StandardCharsets.UTF_8)) {
            writer.write(content);
        }
    }
}
