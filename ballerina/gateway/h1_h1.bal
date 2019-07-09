import ballerina/http;
import ballerina/log;

listener http:Listener passthroughListener = new(9090,
    config = {
        secureSocket: {
            keyStore: {
                path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
                password: "ballerina"
            }
        }
    }
);

http:Client passthroughClient = new("https://localhost:9191",
    config = {
        secureSocket: {
            trustStore: {
                path: "${ballerina.home}/bre/security/ballerinaTruststore.p12",
                password: "ballerina"
            }
        }
    }
);

@http:ServiceConfig { basePath: "/passthrough" }
service passthroughService on passthroughListener {

    @http:ResourceConfig { path: "/" }
    resource function passthrough(http:Caller outboundEP, http:Request clientRequest) {
        var response = passthroughClient->forward("/hello/sayHello", clientRequest);
        if (response is http:Response) {
            checkpanic outboundEP->respond(response);
        } else {
            log:printError("Error at passthrough service", err = response);
            http:Response res = new;
            res.statusCode = http:INTERNAL_SERVER_ERROR_500;
            json errMsg = { message: <string>response.detail().message };
            res.setPayload(errMsg);
            checkpanic outboundEP->respond(res);
        }
    }
}
