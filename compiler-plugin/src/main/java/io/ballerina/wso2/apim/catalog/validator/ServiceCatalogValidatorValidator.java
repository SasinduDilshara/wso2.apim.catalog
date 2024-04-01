package io.ballerina.wso2.apim.catalog.validator;

import io.ballerina.compiler.api.SemanticModel;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.projects.Project;
import io.ballerina.projects.plugins.AnalysisTask;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getOpenApiFileName;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getServiceBasePath;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.resolveContractFileName;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.writeFile;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OAS_PATH_SEPARATOR;
import static io.ballerina.wso2.apim.catalog.utils.Constants.OPENAPI;

public class ServiceCatalogValidatorValidator implements AnalysisTask<SyntaxNodeAnalysisContext> {

    @Override
    public void perform(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {
        if (diagnosticContainsErrors(syntaxNodeAnalysisContext)) {
            return;
        }
        ServiceDeclarationNode serviceDeclarationNode = getServiceDeclarationNode(syntaxNodeAnalysisContext);
        if (serviceDeclarationNode == null) {
            return;
        }
        generateOASForgetServiceDeclarationNode(syntaxNodeAnalysisContext, serviceDeclarationNode);
    }

    private void generateOASForgetServiceDeclarationNode(SyntaxNodeAnalysisContext context,
                                                         ServiceDeclarationNode serviceDeclarationNode) {
        SyntaxTree syntaxTree = context.syntaxTree();
        String openApiFilename = getOpenApiFileName(
                syntaxTree.filePath(), getServiceBasePath(serviceDeclarationNode), false);
        String filepath = syntaxTree.filePath();
        SemanticModel semanticModel = context.semanticModel();
        Project project = context.currentPackage().project();

        OASResult oasResult = generateOASForService(
                serviceDeclarationNode, openApiFilename, filepath, semanticModel, project);
        writeToTargetDirectory(project, oasResult);
    }

    public static OASResult generateOASForService(ServiceDeclarationNode serviceDeclarationNode, String openApiFilename,
                                        String filepath, SemanticModel semanticModel, Project project) {
        OASGenerationMetaInfo.OASGenerationMetaInfoBuilder builder =
                new OASGenerationMetaInfo.OASGenerationMetaInfoBuilder();
        builder.setServiceDeclarationNode(serviceDeclarationNode)
                .setSemanticModel(semanticModel)
                .setOpenApiFileName(openApiFilename)
                .setBallerinaFilePath(filepath)
                .setProject(project);
        OASGenerationMetaInfo oasGenerationMetaInfo = builder.build();
        OASResult oasDefinition = generateOAS(oasGenerationMetaInfo);
        oasDefinition.setServiceName(openApiFilename);
        return oasDefinition;
    }

    public static ServiceDeclarationNode getServiceDeclarationNode(SyntaxNodeAnalysisContext context) {
        return (ServiceDeclarationNode) context.node();
    }

    public static boolean diagnosticContainsErrors(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {
        List<Diagnostic> diagnostics = syntaxNodeAnalysisContext.semanticModel().diagnostics();
        return diagnostics.stream()
                .anyMatch(d -> DiagnosticSeverity.ERROR.equals(d.diagnosticInfo().severity()));
    }

    public void writeToTargetDirectory(Project project, OASResult oasResult) {
        String targetDirectoryPath = project.targetDir().toAbsolutePath().toString();
        try {
            Files.createDirectories(Paths.get(targetDirectoryPath + OAS_PATH_SEPARATOR + OPENAPI));
            String serviceName = oasResult.getServiceName();
            String fileName = resolveContractFileName(targetDirectoryPath.resolve(OPENAPI),
                    serviceName, false);
            writeFile(targetDirectoryPath.resolve(OPENAPI + OAS_PATH_SEPARATOR + fileName), oasResult.getYaml().get());
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
