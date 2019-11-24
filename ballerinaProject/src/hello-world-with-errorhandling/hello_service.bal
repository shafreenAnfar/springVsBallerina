import ballerina/http;
import ballerina/io;

int count = 0;

service hello on new http:Listener(9090) {
    resource function greeting(http:Caller caller, http:Request request) {
        json greeting = createGreetingResponse(request);

        error? result = caller->respond(greeting);
        if (result is error) {
            io:println("Error in responding: ", result);
        }
    }
}

function createGreetingResponse(http:Request inboundRequest) returns json {
    lock {
        count += 1;
    }
    var name = <@untainted>inboundRequest.getQueryParamValue("name");
    string content = string `Hello ${name is string ? name + "!" : "World!"}`;
    json greeting = {id: count, content: content};

    return greeting;
}


