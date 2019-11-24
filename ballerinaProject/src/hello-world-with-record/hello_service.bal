import ballerina/http;

int count = 0;

type Greeting record {
    int id;
    string content;
};

service hello on new http:Listener(9090) {
    resource function greeting(http:Caller caller, http:Request request) returns error? {
        Greeting greeting = createGreetingResponse(request);
        return caller->respond(check json.constructFrom(greeting));
    }
}

function createGreetingResponse(http:Request inboundRequest) returns Greeting {
    lock {
        count += 1;
    }
    var name = <@untainted>inboundRequest.getQueryParamValue("name");
    string content = string `Hello ${name is string ? name + "!" : "World!"}`;
    Greeting greeting = {id: count, content: content};

    return greeting;
}


