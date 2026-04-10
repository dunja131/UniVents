package com.UniVents.EventsManagement.Controllers;

import com.UniVents.EventsManagement.entity.Organiser;
import com.UniVents.EventsManagement.repository.OrganiserRepository;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

@RestController
@RequestMapping("/organisers")
public class OrganiserController {

    @Autowired
    private OrganiserRepository organiserRepository;

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
    public ResponseEntity<Organiser> createOrganiser(@RequestBody Organiser organiser){
        Organiser saved = organiserRepository.save(organiser); 
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }



}

    //Put update the organiser
    //Post create an organiser
    //Delete - delete an organiser
    

