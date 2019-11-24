import ballerina/http;

int count = 0;

service hello on new http:Listener(9090) {
    resource function greeting(http:Caller caller, http:Request request) returns error? {
        json greeting = createGreetingResponse(request);
        return caller->respond(greeting);
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


