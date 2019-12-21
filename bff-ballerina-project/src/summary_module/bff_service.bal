import ballerina/http;

http:Client vehicleBackend = new("http://localhost:9000/vehicle");

type SummaryDetails record {
    string number;
    record {
        string profileImage;
        string name;
        float rating;
    } driver;
};

service summary on new http:Listener(8081) {

    @http:ResourceConfig {
        path:"/vehicle/{id}"    
    }
    resource function vehicleSummary(http:Caller caller, http:Request request, string id) returns error? {
        http:Response vehicleSummary = check vehicleBackend->get(<@untainted> string `/${id}`);

        var responsePayload = check <@untainted> vehicleSummary.getJsonPayload();   
        SummaryDetails summ = check SummaryDetails.constructFrom(responsePayload);
        json trimmedPayload = {vehicleNumber: summ.number, name: summ.driver.name, 
                               profileImage: summ.driver.profileImage, rating:summ.driver.rating};

        check caller->respond(trimmedPayload);
    }
}


