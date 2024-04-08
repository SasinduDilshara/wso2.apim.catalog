package io.ballerina.wso2.apim.catalog.codemodifier;

import io.ballerina.compiler.api.SemanticModel;
import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.AnnotationNode;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.MappingConstructorExpressionNode;
import io.ballerina.compiler.syntax.tree.MappingFieldNode;
import io.ballerina.compiler.syntax.tree.MetadataNode;
import io.ballerina.compiler.syntax.tree.ModuleMemberDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.Node;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SpecificFieldNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.openapi.service.mapper.model.OASGenerationMetaInfo;
import io.ballerina.openapi.service.mapper.model.OASResult;
import io.ballerina.projects.Document;
import io.ballerina.projects.DocumentId;
import io.ballerina.projects.Module;
import io.ballerina.projects.Package;
import io.ballerina.projects.Project;
import io.ballerina.projects.plugins.ModifierTask;
import io.ballerina.projects.plugins.SourceModifierContext;
import io.ballerina.tools.text.TextDocument;
import io.ballerina.wso2.apim.catalog.utils.Constants;
import io.swagger.v3.core.util.Yaml;
import io.swagger.v3.oas.models.OpenAPI;

import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import static io.ballerina.openapi.service.mapper.ServersMapper.getServiceBasePath;
import static io.ballerina.openapi.service.mapper.ServiceToOpenAPIMapper.generateOAS;
import static io.ballerina.openapi.service.mapper.utils.MapperCommonUtils.getOpenApiFileName;
import static io.ballerina.openapi.service.mapper.utils.MapperCommonUtils.normalizeTitle;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.createImportDeclarationNodeForModule;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.createOpenApiDefinitionField;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.diagnosticContainsErrors;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getMetadataNode;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.getServiceCatalogConfigAnnotation;
import static io.ballerina.wso2.apim.catalog.utils.CommonUtils.isServiceCatalogConfigAnnotationAvailable;
import static io.ballerina.wso2.apim.catalog.utils.Constants.SLASH;

public class OpenAPIAnnotationModifier implements ModifierTask<SourceModifierContext> {

    @Override
    public void modify(SourceModifierContext context) {
        // if the compilation already contains any error, do not proceed
        if (diagnosticContainsErrors(context)) {
            return;
        }
        context.currentPackage().compilationOptions().disableSyntaxTree();
        Package currentPackage = context.currentPackage();
        for (Module module: currentPackage.modules()) {
            Collection<DocumentId> documentIds = module.documentIds();
            for (DocumentId documentId: documentIds) {
                Document document = module.document(documentId);
                SyntaxTree syntaxTree = document.syntaxTree();
                ModulePartNode rootNode = syntaxTree.rootNode();
                SemanticModel semanticModel = context.compilation().getSemanticModel(module.moduleId());
                NodeList<ImportDeclarationNode> newImports = updateImports(rootNode.imports(), rootNode.members());

                NodeList<ModuleMemberDeclarationNode> newMembers = updateMemberNodes(
                        syntaxTree, currentPackage, document,
                        currentPackage.project(), rootNode.members(), semanticModel);
                ModulePartNode newModulePart = rootNode.modify(newImports, newMembers, rootNode.eofToken());
                SyntaxTree updatedSyntaxTree = syntaxTree.modifyWith(newModulePart);
                TextDocument textDocument = updatedSyntaxTree.textDocument();
                if (documentIds.contains(documentId)) {
                    context.modifySourceFile(textDocument, documentId);
                } else {
                    context.modifyTestSourceFile(textDocument, documentId);
                }
            }
        }
    }

    private NodeList<ImportDeclarationNode> updateImports(NodeList<ImportDeclarationNode> imports,
                                                          NodeList<ModuleMemberDeclarationNode> members) {
        boolean containsServiceNode = false;
        for (ModuleMemberDeclarationNode memberNode : members) {
            if (memberNode.kind() != SyntaxKind.SERVICE_DECLARATION) {
                continue;
            }
            containsServiceNode = true;
            ServiceDeclarationNode serviceNode = (ServiceDeclarationNode) memberNode;
            NodeList<AnnotationNode> annotations = getMetadataNode(serviceNode).annotations();
            for (AnnotationNode annotation: annotations) {
                if (isServiceCatalogConfigAnnotationAvailable(annotation)) {
                    return imports;
                }
            }
        }
        if (containsServiceNode) {
            return imports.add(createImportDeclarationNodeForModule());
        }
        return imports;
    }

    private NodeList<ModuleMemberDeclarationNode> updateMemberNodes(
            SyntaxTree syntaxTree, Package currentPackage, Document document, Project project,
            NodeList<ModuleMemberDeclarationNode> oldMembers, SemanticModel semanticModel) {
        List<ModuleMemberDeclarationNode> updatedMembers = new LinkedList<>();
        for (ModuleMemberDeclarationNode memberNode : oldMembers) {
            if (memberNode.kind() != SyntaxKind.SERVICE_DECLARATION) {
                updatedMembers.add(memberNode);
                continue;
            }

            ServiceDeclarationNode serviceNode = (ServiceDeclarationNode) memberNode;
            String openAPIDef = generateOASForgetServiceDeclarationNode(
                    serviceNode, syntaxTree, semanticModel, project, currentPackage, document);
            MetadataNode metadataNode = getMetadataNode(serviceNode);
            MetadataNode.MetadataNodeModifier modifier = metadataNode.modify();
            NodeList<AnnotationNode> updatedAnnotations = updateAnnotations(metadataNode.annotations(),
                    openAPIDef);
            modifier.withAnnotations(updatedAnnotations);
            MetadataNode updatedMetadataNode = modifier.apply();
            ServiceDeclarationNode.ServiceDeclarationNodeModifier serviceDecModifier = serviceNode.modify();
            serviceDecModifier.withMetadata(updatedMetadataNode);
            ServiceDeclarationNode updatedServiceDecNode = serviceDecModifier.apply();
            updatedMembers.add(updatedServiceDecNode);
        }
        return AbstractNodeFactory.createNodeList(updatedMembers);
    }

    private NodeList<AnnotationNode> updateAnnotations(NodeList<AnnotationNode> currentAnnotations,
                                                       String openApiDefinition) {
        NodeList<AnnotationNode> updatedAnnotations = NodeFactory.createNodeList();
        boolean serviceCatalogConfigAnnotationUpdated = false;
        for (AnnotationNode annotation: currentAnnotations) {
            if (isServiceCatalogConfigAnnotationAvailable(annotation)) {
                serviceCatalogConfigAnnotationUpdated = true;
                SeparatedNodeList<MappingFieldNode> updatedFields = getUpdatedFields(annotation, openApiDefinition);
                MappingConstructorExpressionNode annotationValue =
                        NodeFactory.createMappingConstructorExpressionNode(
                                NodeFactory.createToken(SyntaxKind.OPEN_BRACE_TOKEN), updatedFields,
                                NodeFactory.createToken(SyntaxKind.CLOSE_BRACE_TOKEN));
                annotation = annotation.modify().withAnnotValue(annotationValue).apply();
            }
            updatedAnnotations = updatedAnnotations.add(annotation);
        }
        if (!serviceCatalogConfigAnnotationUpdated) {
            AnnotationNode openApiAnnotation = getServiceCatalogConfigAnnotation(openApiDefinition);
            updatedAnnotations = updatedAnnotations.add(openApiAnnotation);
        }
        return updatedAnnotations;
    }

    private SeparatedNodeList<MappingFieldNode> getUpdatedFields(AnnotationNode annotation, String openAPIDef) {
        Optional<MappingConstructorExpressionNode> annotationValueOpt = annotation.annotValue();
        if (annotationValueOpt.isEmpty()) {
            return NodeFactory.createSeparatedNodeList(createOpenApiDefinitionField(openAPIDef));
        }
        List<Node> fields = new ArrayList<>();
        MappingConstructorExpressionNode annotationValue = annotationValueOpt.get();
        SeparatedNodeList<MappingFieldNode> existingFields = annotationValue.fields();
        Token separator = NodeFactory.createToken(SyntaxKind.COMMA_TOKEN);
        boolean openApiDefAvailable = false;
        for (MappingFieldNode field : existingFields) {
            if (field instanceof SpecificFieldNode) {
                String fieldName = ((SpecificFieldNode) field).fieldName().toString();
                openApiDefAvailable = Constants.OPEN_API_DEFINITION_FIELD.equals(fieldName.trim());
            }
            fields.add(field);
            fields.add(separator);
        }
        if (openApiDefAvailable) {
            if (fields.size() != 0) {
                fields.remove(fields.size() - 1);
            }
        } else {
            fields.add(createOpenApiDefinitionField(openAPIDef));
        }
        return NodeFactory.createSeparatedNodeList(fields);
    }

    private String generateOASForgetServiceDeclarationNode(ServiceDeclarationNode serviceDeclarationNode,
                                       SyntaxTree syntaxTree, SemanticModel semanticModel,
                                       Project project, Package currentPackage, Document document) {
        String openApiFilename = getOpenApiFileName(
                syntaxTree.filePath(), getServiceBasePath(serviceDeclarationNode), false);
        Optional<Path> path = currentPackage.project().documentPath(document.documentId());
        Path filepath = path.orElse(null);

        OASResult oasResult = generateOASForService(
                serviceDeclarationNode, openApiFilename, filepath, semanticModel, project);
        oasResult.setServiceName(openApiFilename);
        Optional<OpenAPI> openApiOpt = oasResult.getOpenAPI();
        if (!oasResult.getDiagnostics().isEmpty() || openApiOpt.isEmpty()) {
            return null;
        }
        OpenAPI openApi = openApiOpt.get();
        if (openApi.getInfo().getTitle() == null || openApi.getInfo().getTitle().equals(SLASH)) {
            openApi.getInfo().setTitle(normalizeTitle(openApiFilename));
        }
        String openApiDefinition = Yaml.pretty(openApi);
        return openApiDefinition;
    }

    public static OASResult generateOASForService(ServiceDeclarationNode serviceDeclarationNode,
                        String openApiFilename, Path filepath, SemanticModel semanticModel, Project project) {
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
}
