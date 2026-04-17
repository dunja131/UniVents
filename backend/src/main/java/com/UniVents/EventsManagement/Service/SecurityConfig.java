package com.UniVents.EventsManagement.Service;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import com.UniVents.EventsManagement.entity.User;
import com.UniVents.EventsManagement.repository.UserRepository;
import org.springframework.security.config.Customizer;
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
                .roles("USER") // for now, all users have same role. can add more roles and logic later. 
                .build();
    };
}

@Bean
public org.springframework.security.web.SecurityFilterChain filterChain(org.springframework.security.config.annotation.web.builders.HttpSecurity http) throws Exception {
    http
            .csrf(csrf -> csrf.disable())

           .authorizeHttpRequests(authz -> authz
         .requestMatchers("/register", "/login", "/users/register").permitAll()
            .anyRequest().authenticated()
        )
            .httpBasic(Customizer.withDefaults())
            .formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/", true)
                .permitAll()
             )
             .logout(logout -> logout.permitAll());

    return http.build();

}
}

//SecurityFilterChain
