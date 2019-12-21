import ballerina/http;

http:Client vehicleBackend = new("http://rent.vehicle.com:9000/vehicle");

type SummaryDetails record {
    string number;
    record {
        string profileImage;
        string name;
        float rating;
    } driver;
};

service vehicle on new http:Listener(8081) {

    @http:ResourceConfig {
        path:"/{id}/summary"    
    }
    resource function summary(http:Caller caller, http:Request request, string id) returns error? {
        http:Response vehicleDetails = check vehicleBackend->get(<@untainted> string `/${id}`);

        var responsePayload = check <@untainted> vehicleDetails.getJsonPayload();   
        SummaryDetails summ = check SummaryDetails.constructFrom(responsePayload);
        json trimmedPayload = {vehicleNumber: summ.number, name: summ.driver.name, 
                               profileImage: summ.driver.profileImage, rating:summ.driver.rating};

        check caller->respond(trimmedPayload);
    }
}




