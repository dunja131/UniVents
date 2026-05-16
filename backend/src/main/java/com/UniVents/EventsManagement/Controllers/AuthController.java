package com.UniVents.EventsManagement.Controllers;

import com.UniVents.EventsManagement.Service.JwtUtil;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthenticationManager authManager;
    private final JwtUtil jwtUtil;

    public AuthController(AuthenticationManager authManager, JwtUtil jwtUtil) {
        this.authManager = authManager;
        this.jwtUtil = jwtUtil;
    }

   @PostMapping("/login")
public ResponseEntity<?> login(@RequestBody Map<String, String> body) {
    try {
        Authentication auth = authManager.authenticate(
            new UsernamePasswordAuthenticationToken(body.get("email"), body.get("password"))
        );

        String role = auth.getAuthorities().iterator().next().getAuthority();

      
        String token = jwtUtil.generateToken(auth.getName(), "STUDENT");

        return ResponseEntity.ok(Map.of(
            "token", token,
            "role", role
        ));
    } catch (AuthenticationException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid credentials");
    }
}
}