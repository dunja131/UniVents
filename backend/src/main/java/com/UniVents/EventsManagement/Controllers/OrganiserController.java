package com.UniVents.EventsManagement.Controllers;

import com.UniVents.EventsManagement.entity.Organiser;
import com.UniVents.EventsManagement.repository.OrganiserRepository;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

@RestController
@RequestMapping("/organisers")
public class OrganiserController {

    // @Autowired
    private OrganiserRepository organiserRepository;
    private final BCryptPasswordEncoder passwordEncoder;

    public OrganiserController(OrganiserRepository organiserRepository, BCryptPasswordEncoder passwordEncoder) {
        this.organiserRepository = organiserRepository;
        this.passwordEncoder = passwordEncoder;
    }

    // GET /organisers - all organisers
    @GetMapping
    public List<Organiser> getAllOrganisers() {
        return organiserRepository.findAll();
    }

    // GET /organisers/{id} - one organiser
    @GetMapping("/{id}")
    public ResponseEntity<Organiser> getOrganiserById(@PathVariable Long id) {
        Optional<Organiser> organiser = organiserRepository.findById(id);
        if (organiser.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(organiser.get());
    }

    // POST /organisers - create an organiser
    @PostMapping
    public ResponseEntity<Organiser> createOrganiser(@RequestBody Organiser organiser) {
        Organiser saved = organiserRepository.save(organiser);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    // PUT /organisers/{id} - update an organiser (i.e. if needed to change email)
    @PutMapping("/{id}")
    public ResponseEntity<Organiser> updateOrganiser(@PathVariable Long id, @RequestBody Organiser updatedOrganiser) {

        Optional<Organiser> existingOrganiser = organiserRepository.findById(id);

        if (existingOrganiser.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Organiser organiser = existingOrganiser.get();
        organiser.setOrganiserName(updatedOrganiser.getOrganiserName());
        organiser.setOrganiserEmail(updatedOrganiser.getOrganiserEmail());

        return ResponseEntity.ok(organiserRepository.save(organiser));
    }

    // POST /organisers/register
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestParam String firstName, @RequestParam String lastName,
            @RequestParam String email, @RequestParam String password) {
        Organiser organiser = new Organiser();
        organiser.setOrganiserName(firstName + " " + lastName);
        organiser.setOrganiserEmail(email);
        organiser.setOrganiserPassword(passwordEncoder.encode(password));

        if (organiserRepository.findByOrganiserEmail(organiser.getOrganiserEmail()).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Email already in use");
        }
        Organiser saved = organiserRepository.save(organiser);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    // POST /organisers/login
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Organiser loginRequest) {
        Optional<Organiser> organiser = organiserRepository.findByOrganiserEmail(loginRequest.getOrganiserEmail());

        if (organiser.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Organiser not found");
        }
        if (!organiser.get().getOrganiserPassword().equals(loginRequest.getOrganiserPassword())) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Incorrect password");
        }

        return ResponseEntity.ok(organiser.get());
    }

    @GetMapping("/my-profile")
    public Organiser getOrganiserProfile(Authentication authentication) {
        String email = authentication.getName();

        return organiserRepository.findByOrganiserEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Organiser not found"));

    }

}
