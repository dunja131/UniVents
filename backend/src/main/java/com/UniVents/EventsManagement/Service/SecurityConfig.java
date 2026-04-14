package com.UniVents.EventsManagement.Service;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;


import com.UniVents.EventsManagement.entity.User;
import com.UniVents.EventsManagement.repository.UserRepository;

@Configuration 
@EnableWebSecurity
public class SecurityConfig {
    


@Bean BCryptPasswordEncoder passwordEncoder() { // encodes passwords before saving new users. 
    return new BCryptPasswordEncoder();
}

@Bean
UserDetailsService userDetailsService (UserRepository repo) { // tells spring how to find users in database.
    return username -> {
        User user = repo.findByEmail(username)
            .orElseThrow(() -> new UsernameNotFoundException("User not found"));

        return  org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPasswordHash())
                .roles(user.getRole().name())  
                .build();
    };
}

@Bean
public org.springframework.security.web.SecurityFilterChain filterChain(org.springframework.security.config.annotation.web.builders.HttpSecurity http) throws Exception {
    http     
            .csrf(csrf -> csrf.disable())
   
           .authorizeHttpRequests(authz -> authz
         .requestMatchers("/login", "/users/register").permitAll() // allow anyone to access registration endpoint

            //role-based rules
                .requestMatchers(HttpMethod.POST, "/events").hasRole("ORGANISER") //only organiser permitted to create events
                .requestMatchers(HttpMethod.PUT, "/events/**").hasRole("ORGANISER") //only organiser can edit an existing event
                .requestMatchers(HttpMethod.DELETE, "/events/**").hasRole("ORGANISER") //only organiser can delete event
                .requestMatchers(HttpMethod.GET, "/events/*/rsvps").hasRole("ORGANISER") //only organiser can see full rsvp list
                
                .requestMatchers(HttpMethod.POST, "/events/*/rsvp").hasRole("STUDENT") //only student can rsvp to an event
                .requestMatchers(HttpMethod.DELETE, "/events/*/rsvp").hasRole("STUDENT") //only student can delete their rsvp from an event
                
                //both can view events through browsing feed & seeing event details
                .requestMatchers(HttpMethod.GET, "/events/**").hasAnyRole("STUDENT", "ORGANISER") 

            .anyRequest().authenticated() // require authentication for all other endpoints
        )
            .formLogin(form -> form // overrides the API they built to create a loginform instead.
                .loginPage("/login")
                .defaultSuccessUrl("/", true)
                .permitAll()
             )
             .logout(logout -> logout.permitAll());

    return http.build();

}


}