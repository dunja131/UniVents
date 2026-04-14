package com.UniVents.EventsManagement.Controllers;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.GetMapping;

 @Controller // changed from @restcontroller since it returns a html view not json. 
public class LoginController {
    @GetMapping("/login")
public String login(){
    System.out.println("Login endpoint hit");
return "login";
}

    @GetMapping("/register")
public String register(){
return "register";
}

    @GetMapping("/")
public String homepage(){
return "homepage";
}

}

