package com.example.consumingrest;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
public class SummaryRestApplication {

    @Autowired
    RestTemplate restTemplate;

    public static void main(String[] args) {
        SpringApplication.run(SummaryRestApplication.class, args);
    }

    @Bean
    public RestTemplate getRestTemplate() {
        return new RestTemplate();
    }

    @RestController
    @RequestMapping("/vehicle")
    class SummaryVehicalController {

        @RequestMapping("/{id}/summary")
        public VehicleSummary vehicleSummary(@PathVariable("id") String id) {
            String vehicleEndpoint = "http://rent.vehicle.com:9000/vehicle/" + id;
            AvailableVehicles availableVehicles =
                    restTemplate.getForObject(vehicleEndpoint, AvailableVehicles.class);
            return VehicleSummeryMapper.INSTANCE.vehicleDetailToVehicleSummery(availableVehicles);
        }
    }
}

class AvailableVehicles {

    private String number;
    private Driver driver;

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Driver getDriver() {
        return driver;
    }

    public void setDriver(Driver driver) {
        this.driver = driver;
    }
}

class Driver {

    private String profileImage;
    private String name;
    private float rating;

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }
}

class VehicleSummary {

    private String vehicleNumber;
    private String name;
    private String profileImage;
    private float rating;

    public String getVehicleNumber() {
        return vehicleNumber;
    }

    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }
}

@Mapper
interface VehicleSummeryMapper {

    VehicleSummeryMapper INSTANCE = Mappers.getMapper(VehicleSummeryMapper.class);

    @Mapping(source = "driver.name", target = "name")
    @Mapping(source = "driver.profileImage", target = "profileImage")
    @Mapping(source = "driver.rating", target = "rating")
    @Mapping(source = "number", target = "vehicleNumber")
    VehicleSummary vehicleDetailToVehicleSummery(AvailableVehicles availableVehicles);
}


