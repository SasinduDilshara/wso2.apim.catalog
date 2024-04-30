import ballerina/http;
import ballerinax/wso2.apim.catalog as _;

service /sales on new http:Listener(9811) {
    resource function get orders() returns http:Created? {
        return;
    }

    resource function get orders/customers/[string customerName]() returns http:Ok|http:InternalServerError {
        return <http:Ok>{body: {message: ""}};
    }

    resource function get orders/[string customerName]/items(string customer, string itemName) returns error? {
        return;
    }
}
