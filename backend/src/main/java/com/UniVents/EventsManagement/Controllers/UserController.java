package com.UniVents.EventsManagement.Controllers;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.UniVents.EventsManagement.entity.User;
import com.UniVents.EventsManagement.entity.User.Role;
import com.UniVents.EventsManagement.repository.UserRepository;
// controls user related requests in login and signup. 
@RestController

@RequestMapping("/users")
public class UserController {
       // @Autowired 

     private final UserRepository userRepository;
     private final BCryptPasswordEncoder passwordEncoder;

public UserController (UserRepository userRepository, BCryptPasswordEncoder passwordEncoder){
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoder;
}

    @GetMapping("/my-profile")
    public User getUser (Authentication authentication) {
    String email = authentication.getName();

    return userRepository.findByEmail(email)
            .orElseThrow(() -> new UsernameNotFoundException("User not found"));

    }

        @PostMapping("/register")
        public void register(@RequestParam String firstName, @RequestParam String lastName,
                       @RequestParam String email, @RequestParam String password) {
                        System.out.println("REGISTER HIT");  
            User newUser = new User();
            //frontend will need to have fields set with same names so DTO can map user properly. 
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);
            newUser.setEmail(email);
            newUser.setPasswordHash(passwordEncoder.encode(password));
            newUser.setRole(Role.STUDENT);
            
            userRepository.save(newUser);
        }



    }




// done so far - made backend project with springboot initializer using maven
// downloaded extension pack for java + jdk extensions so it imports packages and functions as an IDE (vscode is just text editor)
// ./mvnw spring-boot:run to run app 
// go to http://localhost:8080 to access.
// added spring-boot-devtools in dependencies so can just reload page and it will update changes (otherwise have to end run command and repaste it.) 
// ctrl + c to end a command in terminal.

// kimi 15/04
// not sure how to determine student vs orgasniser role when registering - need to discuss with team if we are going 
// to have option for register as student or register as organiser and how to do security checks to permit organiser role
//at this stage - defaulting role to student for milestone one, will follow up later as not a core functionality :-) 