package com.UniVents.EventsManagement.Controllers;

import com.UniVents.EventsManagement.entity.Rsvp;
import com.UniVents.EventsManagement.repository.RsvpRepository;


import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;


@RestController  // tells Spring this class handles HTTP requests
@RequestMapping("/rsvps") //
public class RsvpController{

    @Autowired 
    private RsvpRepository rsvpRepository; //connects to the database

    // POST /rsvps - create RSVP
    @PostMapping
    public ResponseEntity<Rsvp> createRsvp(@RequestBody Rsvp rsvp) {
        Rsvp saved = rsvpRepository.save(rsvp);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
    //GET /rsvps/event/{eventId} - get all RSVPs for an event
    @GetMapping("/event/{eventId}")
    public List<Rsvp> getRsvpsByEvent(@PathVariable Long eventId){
        return rsvpRepository.findByEvent_EventId(eventId);
    }

    // GET /rsvps/user/{userId} - get all RSVPs for a user
    @GetMapping("/user/{userId}")
    public List<Rsvp> getRsvpsByUser(@PathVariable Long userId){
        return rsvpRepository.findByUser_UserId(userId);
    }

    // PUT - update RSVPs going, maybe, not going
    // PUT /rsvps/{id} - update RSVP status
    @PutMapping("/{id}")


}