package com.UniVents.EventsManagement.Service;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import com.UniVents.EventsManagement.entity.User;
import com.UniVents.EventsManagement.repository.UserRepository;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration 
@EnableWebSecurity
public class SecurityConfig {
    
private final JwtFilter jwtFilter;
public SecurityConfig(JwtFilter jwtFilter) {
    this.jwtFilter = jwtFilter;
}

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
public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
    return config.getAuthenticationManager();
}

@Bean
public org.springframework.security.web.SecurityFilterChain filterChain(org.springframework.security.config.annotation.web.builders.HttpSecurity http) throws Exception {
    http
            .csrf(csrf -> csrf.disable())

           .authorizeHttpRequests(authz -> authz
         .requestMatchers("/register", "/login", "/users/register").permitAll()
              .requestMatchers("/api/auth/**").permitAll() // login endpoint open
                  .requestMatchers("/api/**").authenticated() // all other API routes need token
            .anyRequest().authenticated()
        )
         //   .httpBasic(Customizer.withDefaults())
            .formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/", true)
                .permitAll()
             )
             .logout(logout -> logout.permitAll())
            
             // jwt runs before spring security checks if user is authenticated. if jwt is valid, it will set user as authenticated in spring security context.
             .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);
        

    return http.build();

}
}

//SecurityFilterChain
