package io.ballerina.wso2.apim.catalog.codeanalyzer;

import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.projects.plugins.CodeAnalysisContext;
import io.ballerina.projects.plugins.CodeAnalyzer;
import io.ballerina.wso2.apim.catalog.validator.ServiceCatalogValidatorValidator;

public class ServiceCatalogCodeAnalyzer extends CodeAnalyzer {

    @Override
    public void init(CodeAnalysisContext codeAnalysisContext) {
        codeAnalysisContext.addSyntaxNodeAnalysisTask(
                new ServiceCatalogValidatorValidator(), SyntaxKind.SERVICE_DECLARATION);
    }
}
