package io.ballerina.wso2.apim.catalog.codemodifier;

import io.ballerina.projects.plugins.CodeModifier;
import io.ballerina.projects.plugins.CodeModifierContext;

public class ServiceCatalogModifier extends CodeModifier {

    @Override
    public void init(CodeModifierContext codeModifierContext) {
        codeModifierContext.addSourceModifierTask(new OpenAPIAnnotationModifier());
    }
}
