//package io.ballerina.wso2.apim.catalog.validator;
//
//import io.ballerina.compiler.api.SemanticModel;
//import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
//import io.ballerina.compiler.syntax.tree.SyntaxTree;
//import io.ballerina.openapi.service.mapper.model.OASGenerationMetaInfo;
//import io.ballerina.openapi.service.mapper.model.OASResult;
//import io.ballerina.projects.Package;
//import io.ballerina.projects.Project;
//import io.ballerina.projects.plugins.AnalysisTask;
//import io.ballerina.projects.plugins.SyntaxNodeAnalysisContext;
//import io.ballerina.tools.diagnostics.Diagnostic;
//import io.ballerina.tools.diagnostics.DiagnosticSeverity;
//
//import java.nio.file.Path;
//import java.util.List;
//import java.util.Optional;
//
//import static io.ballerina.openapi.service.mapper.ServersMapper.getServiceBasePath;
//import static io.ballerina.openapi.service.mapper.ServiceToOpenAPIMapper.generateOAS;
//import static io.ballerina.openapi.service.mapper.utils.MapperCommonUtils.getOpenApiFileName;
//
//public class ServiceCatalogValidator implements AnalysisTask<SyntaxNodeAnalysisContext> {
//
//    @Override
//    public void perform(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {
//        if (diagnosticContainsErrors(syntaxNodeAnalysisContext)) {
//            return;
//        }
//        ServiceDeclarationNode serviceDeclarationNode = getServiceDeclarationNode(syntaxNodeAnalysisContext);
//        // TODO: Check the annotation is there and return null
//
//        if (serviceDeclarationNode == null) {
//            return;
//        }
//        generateOASForgetServiceDeclarationNode(syntaxNodeAnalysisContext, serviceDeclarationNode);
//    }
//
//    private OASResult generateOASForgetServiceDeclarationNode(SyntaxNodeAnalysisContext context,
//                                                              ServiceDeclarationNode serviceDeclarationNode) {
//        SyntaxTree syntaxTree = context.syntaxTree();
//        Package currentPackage = context.currentPackage();
//        String openApiFilename = getOpenApiFileName(
//                syntaxTree.filePath(), getServiceBasePath(serviceDeclarationNode), false);
//        Optional<Path> path = currentPackage.project().documentPath(context.documentId());
//        Path filepath = path.orElse(null);
//        SemanticModel semanticModel = context.semanticModel();
//        Project project = context.currentPackage().project();
//
//        OASResult oasResult = generateOASForService(
//                serviceDeclarationNode, openApiFilename, filepath, semanticModel, project);
//        return oasResult;
//    }
//
//    public static OASResult generateOASForService(ServiceDeclarationNode serviceDeclarationNode,
//                String openApiFilename, Path filepath, SemanticModel semanticModel, Project project) {
//        OASGenerationMetaInfo.OASGenerationMetaInfoBuilder builder =
//                new OASGenerationMetaInfo.OASGenerationMetaInfoBuilder();
//        builder.setServiceDeclarationNode(serviceDeclarationNode)
//                .setSemanticModel(semanticModel)
//                .setOpenApiFileName(openApiFilename)
//                .setBallerinaFilePath(filepath)
//                .setProject(project);
//        OASGenerationMetaInfo oasGenerationMetaInfo = builder.build();
//        OASResult oasDefinition = generateOAS(oasGenerationMetaInfo);
//        oasDefinition.setServiceName(openApiFilename);
//        return oasDefinition;
//    }
//
//    public static ServiceDeclarationNode getServiceDeclarationNode(SyntaxNodeAnalysisContext context) {
//        return (ServiceDeclarationNode) context.node();
//    }
//
//    public static boolean diagnosticContainsErrors(SyntaxNodeAnalysisContext syntaxNodeAnalysisContext) {
//        List<Diagnostic> diagnostics = syntaxNodeAnalysisContext.semanticModel().diagnostics();
//        return diagnostics.stream()
//                .anyMatch(d -> DiagnosticSeverity.ERROR.equals(d.diagnosticInfo().severity()));
//    }
//}
