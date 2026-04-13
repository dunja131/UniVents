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

    //PUT /organisers/{id} - update an organiser (i.e. if needed to change email)

    @PutMapping("/{id}")
    public ResponseEntity<Organiser> updateOrganiser(@PathVariable Long id, @RequestBody Organiser updatedOrganiser){

        Optional<Organiser> existingOrganiser = organiserRepository.findById(id);

        if (existingOrganiser.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Organiser organiser = existingOrganiser.get();
        organiser.setOrganiserName(updatedOrganiser.getOrganiserName());
        organiser.setOrganiserEmail(updatedOrganiser.getOrganiserEmail());

        return ResponseEntity.ok(organiserRepository.save(organiser));
    }   

}

   

    

