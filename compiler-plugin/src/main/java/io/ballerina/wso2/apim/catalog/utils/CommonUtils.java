package io.ballerina.wso2.apim.catalog.utils;

import io.ballerina.compiler.syntax.tree.AbstractNodeFactory;
import io.ballerina.compiler.syntax.tree.AnnotationNode;
import io.ballerina.compiler.syntax.tree.ExpressionNode;
import io.ballerina.compiler.syntax.tree.IdentifierToken;
import io.ballerina.compiler.syntax.tree.MappingConstructorExpressionNode;
import io.ballerina.compiler.syntax.tree.MappingFieldNode;
import io.ballerina.compiler.syntax.tree.MetadataNode;
import io.ballerina.compiler.syntax.tree.NodeFactory;
import io.ballerina.compiler.syntax.tree.NodeList;
import io.ballerina.compiler.syntax.tree.NodeParser;
import io.ballerina.compiler.syntax.tree.QualifiedNameReferenceNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.compiler.syntax.tree.ServiceDeclarationNode;
import io.ballerina.compiler.syntax.tree.SimpleNameReferenceNode;
import io.ballerina.compiler.syntax.tree.SpecificFieldNode;
import io.ballerina.compiler.syntax.tree.SyntaxKind;
import io.ballerina.compiler.syntax.tree.Token;
import io.ballerina.projects.plugins.SourceModifierContext;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;

import java.nio.charset.Charset;
import java.util.Base64;

public class CommonUtils {
    public static MetadataNode getMetadataNode(ServiceDeclarationNode serviceNode) {
        return serviceNode.metadata().orElseGet(() -> {
            NodeList<AnnotationNode> annotations = NodeFactory.createNodeList();
            return NodeFactory.createMetadataNode(null, annotations);
        });
    }
    public static boolean diagnosticContainsErrors(SourceModifierContext context) {
        return context.compilation().diagnosticResult()
                .diagnostics().stream()
                .anyMatch(d -> DiagnosticSeverity.ERROR.equals(d.diagnosticInfo().severity()));
    }

    public static AnnotationNode getServiceCatalogConfigAnnotation(String openApiDefinition) {
        String configIdentifierString = Constants.SERVICE_CATALOG_PACKAGE_NAME + SyntaxKind.COLON_TOKEN.stringValue() +
                Constants.SERVICE_CATALOG_METADATA_ANNOTATION_IDENTIFIER;
        IdentifierToken identifierToken = NodeFactory.createIdentifierToken(configIdentifierString);
        Token atToken = NodeFactory.createToken(SyntaxKind.AT_TOKEN);
        SimpleNameReferenceNode nameReferenceNode = NodeFactory.createSimpleNameReferenceNode(identifierToken);
        MappingConstructorExpressionNode annotValue = getAnnotationExpression(openApiDefinition);
        return NodeFactory.createAnnotationNode(atToken, nameReferenceNode, annotValue);
    }

    public static MappingConstructorExpressionNode getAnnotationExpression(String openApiDefinition) {
        Token openBraceToken = NodeFactory.createToken(SyntaxKind.OPEN_BRACE_TOKEN);
        Token closeBraceToken = NodeFactory.createToken(SyntaxKind.CLOSE_BRACE_TOKEN);
        SpecificFieldNode specificFieldNode = createOpenApiDefinitionField(openApiDefinition);
        SeparatedNodeList<MappingFieldNode> separatedNodeList = NodeFactory.createSeparatedNodeList(specificFieldNode);
        return NodeFactory.createMappingConstructorExpressionNode(openBraceToken, separatedNodeList, closeBraceToken);
    }
    public static SpecificFieldNode createOpenApiDefinitionField(String openApiDefinition) {
        IdentifierToken fieldName = AbstractNodeFactory.createIdentifierToken(Constants.OPEN_API_DEFINITION_FIELD);
        Token colonToken = AbstractNodeFactory.createToken(SyntaxKind.COLON_TOKEN);
        String encodedValue = Base64.getEncoder().encodeToString(openApiDefinition.getBytes(Charset.defaultCharset()));
        ExpressionNode expressionNode = NodeParser.parseExpression(
                String.format("base64 `%s`.cloneReadOnly()", encodedValue));
        return NodeFactory.createSpecificFieldNode(null, fieldName, colonToken, expressionNode);
    }
    public static boolean isServiceCatalogConfigAnnotation(AnnotationNode annotationNode) {
        if (!(annotationNode.annotReference() instanceof QualifiedNameReferenceNode)) {
            return false;
        }
        QualifiedNameReferenceNode referenceNode = ((QualifiedNameReferenceNode) annotationNode.annotReference());
        if (!Constants.SERVICE_CATALOG_PACKAGE_NAME.equals(referenceNode.modulePrefix().text())) {
            return false;
        }
        return Constants.SERVICE_CATALOG_METADATA_ANNOTATION_IDENTIFIER.equals(referenceNode.identifier().text());
    }

//    public static boolean isOpenAPIInfoAnnotation(AnnotationNode annotationNode) {
//        if (!(annotationNode.annotReference() instanceof QualifiedNameReferenceNode)) {
//            return false;
//        }
//        QualifiedNameReferenceNode referenceNode = ((QualifiedNameReferenceNode) annotationNode.annotReference());
//        if (!Constants.OPENAPI_PACKAGE_NAME.equals(referenceNode.modulePrefix().text())) {
//            return false;
//        }
//        return Constants.OPENAPI_METADATA_ANNOTATION_IDENTIFIER.equals(referenceNode.identifier().text());
//    }
//    public static boolean isSpecGenerationAllowed(ServiceDeclarationNode serviceNode) {
//        NodeList<AnnotationNode> annotations = getMetadataNode(serviceNode).annotations();
//        for (AnnotationNode annotationNode: annotations) {
//            if (!isOpenAPIInfoAnnotation(annotationNode)) {
//                continue;
//            }
//
//            Optional<MappingConstructorExpressionNode> annotationValueOpt = annotationNode.annotValue();
//            if (annotationValueOpt.isEmpty()) {
//                return true;
//            }
//            MappingConstructorExpressionNode annotationValue = annotationValueOpt.get();
//            SeparatedNodeList<MappingFieldNode> existingFields = annotationValue.fields();
//            for (MappingFieldNode field : existingFields) {
//                if (field instanceof SpecificFieldNode) {
//                    SpecificFieldNode specificField = (SpecificFieldNode) field;
//                    String fieldName = specificField.fieldName().toString();
//                    if (Constants.EMBED_FIELD.equals(fieldName.trim())) {
//                        specificField.valueExpr().
//                    }
//                }
//            }
//        }
//        return true;
//    }
}
