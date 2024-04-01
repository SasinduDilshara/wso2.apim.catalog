package io.ballerina.wso2.apim.catalog.codemodifier;

import io.ballerina.compiler.api.SemanticModel;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.openapi.service.mapper.model.OASGenerationMetaInfo;
import io.ballerina.openapi.service.mapper.model.OASResult;
import io.ballerina.projects.Document;
import io.ballerina.projects.DocumentId;
import io.ballerina.projects.Module;
import io.ballerina.projects.ModuleId;
import io.ballerina.projects.Package;
import io.ballerina.projects.Project;
import io.ballerina.projects.plugins.ModifierTask;
import io.ballerina.projects.plugins.SourceModifierContext;
import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;

import java.nio.file.Path;
import java.util.Collection;
import java.util.Optional;

import static io.ballerina.openapi.service.mapper.ServersMapper.getServiceBasePath;
import static io.ballerina.openapi.service.mapper.ServiceToOpenAPIMapper.generateOAS;
import static io.ballerina.openapi.service.mapper.utils.MapperCommonUtils.getOpenApiFileName;

public class ServiceAnnotationModifier
        implements ModifierTask<SourceModifierContext> {

    @Override
    public void modify(SourceModifierContext context) {
        // if the compilation already contains any error, do not proceed
        if (diagnosticContainsErrors(context)) {
            return;
        }
        for (Module module: context.currentPackage().modules()) {
            ModuleId moduleId = module.moduleId();
            Collection<DocumentId> documentIds = module.documentIds();
            for (DocumentId documentId: documentIds) {
                Document document = module.document(documentId);
                
            }
        }
        updateMembers();
    }

    private void updateMembers() {

    }

    private OASResult generateOASForgetServiceDeclarationNode(SyntaxNodeAnalysisContext context,
                                                              ServiceDeclarationNode serviceDeclarationNode) {
        SyntaxTree syntaxTree = context.syntaxTree();
        Package currentPackage = context.currentPackage();
        String openApiFilename = getOpenApiFileName(
                syntaxTree.filePath(), getServiceBasePath(serviceDeclarationNode), false);
        Optional<Path> path = currentPackage.project().documentPath(context.documentId());
        Path filepath = path.orElse(null);
        SemanticModel semanticModel = context.semanticModel();
        Project project = context.currentPackage().project();

        OASResult oasResult = generateOASForService(
                serviceDeclarationNode, openApiFilename, filepath, semanticModel, project);
        return oasResult;
    }

    public static OASResult generateOASForService(ServiceDeclarationNode serviceDeclarationNode, String openApiFilename,
                                                  Path filepath, SemanticModel semanticModel, Project project) {
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

    public static boolean diagnosticContainsErrors(SourceModifierContext context) {
        return context.compilation().diagnosticResult()
                .diagnostics().stream()
                .anyMatch(d -> DiagnosticSeverity.ERROR.equals(d.diagnosticInfo().severity()));
    }
}
