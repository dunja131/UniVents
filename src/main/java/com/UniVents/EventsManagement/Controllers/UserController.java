package com.UniVents.EventsManagement.Controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;


// controls user related requests in login and signup. 
@RestController
public class UserController {
       @GetMapping("/hello")    
    public String hello() {
        return "wooow World!";
    }
 
}



// done so far - made backend project with springboot initializer using maven
// downloaded extension pack for java + jdk extensions so it imports packages and functions as an IDE (vscode is just text editor)
// ./mvnw spring-boot:run to run app 
// go to http://localhost:8080 to access.
// added spring-boot-devtools in dependencies so can just reload page and it will update changes (otherwise have to end run command and repaste it.) 
// ctrl + c to end a command in terminal.  