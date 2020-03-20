import ballerina/http;
import ballerina/log;

http:Client clientEP = new("http://localhost:9090");

public function main() {
    var respGet = clientEP->get("/passthrough");
    if (respGet is http:Response) {
        var payload = respGet.getTextPayload();
        if (payload is string) {
            log:printInfo(payload);
        } else {
            log:printError(<string>payload.detail()?.message);
        }
    } else {
        log:printError(<string>respGet.detail()?.message);
    }

    var respPost = clientEP->post("/passthrough", "Hello Ballerina!");
    if (respPost is http:Response) {
        var payload = respPost.getTextPayload();
        if (payload is string) {
            log:printInfo(payload);
        } else {
            log:printError(<string>payload.detail()?.message);
        }
    } else {
        log:printError(<string>respPost.detail()?.message);
    }
}
