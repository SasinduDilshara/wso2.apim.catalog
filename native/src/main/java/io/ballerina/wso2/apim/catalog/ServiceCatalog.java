package io.ballerina.wso2.apim.catalog;

import io.ballerina.runtime.api.Artifact;
import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.wso2.apim.catalog.utils.Constants;

public class ServiceCatalog {
    public static BArray getArtifacts(Environment env) {
        RecordType recordType = TypeCreator.createRecordType(Constants.SERVICE_ARTIFACT_TYPE_NAME,
                env.getCurrentModule(), 0, false, 0);
        ArrayType arrayType = TypeCreator.createArrayType(recordType);
        BArray arrayValue = ValueCreator.createArrayValue(arrayType);

        for (Artifact artifact: env.getRepository().getArtifacts()) {
            arrayValue.append(artifact);
        }
        return arrayValue;
    }
}
