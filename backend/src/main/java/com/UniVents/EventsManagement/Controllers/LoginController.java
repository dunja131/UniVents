package com.UniVents.EventsManagement.Controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class LoginController {
    @GetMapping("/")
public String homepage(){
return "Welcome to UniVents";
}

}

//