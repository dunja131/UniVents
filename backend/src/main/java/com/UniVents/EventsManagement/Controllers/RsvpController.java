package com.UniVents.EventsManagement.Controllers;

import com.UniVents.EventsManagement.entity.Rsvp;
import com.UniVents.EventsManagement.repository.RsvpRepository;


import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Map;

@RestController  // tells Spring this class handles HTTP requests
@RequestMapping("/api/rsvps") //changed to /api/rsvps
public class RsvpController{

    @Autowired 
    private RsvpRepository rsvpRepository; //connects to the database

    // POST /rsvps - create RSVP
    @PostMapping
    public ResponseEntity<Void> createRsvp(@RequestBody Rsvp rsvp) {
    rsvpRepository.save(rsvp);
    return ResponseEntity.status(HttpStatus.CREATED).build(); 
}
    //GET /rsvps/event/{eventId} - get all RSVPs for an event
    @GetMapping("/event/{eventId}")
    public List<Rsvp> getRsvpsByEvent(@PathVariable Long eventId){
        return rsvpRepository.findByEvent_EventId(eventId);
    }

    // GET /rsvps/user/{userId} - get all RSVPs for a user
    @GetMapping("/user/{userId}")
public ResponseEntity<List<Map<String, Object>>> getRsvpsByUser(@PathVariable Long userId) {
    List<Rsvp> rsvps = rsvpRepository.findByUser_UserId(userId);
    

    List<Map<String, Object>> result = rsvps.stream().map(r -> {
        Map<String, Object> map = new java.util.HashMap<>();
        map.put("rsvpId", r.getRsvpId());
        map.put("status", r.getStatus());
        map.put("event", Map.of("eventId", r.getEvent().getEventId()));
        return map;
    }).toList();
    
    return ResponseEntity.ok(result);
}

    // PUT - update RSVPs going, maybe, not going
    // PUT /rsvps/{id} - update RSVP status
    @PutMapping("/{id}")
    public ResponseEntity<Rsvp> updateRsvp(@PathVariable Long id, @RequestBody Rsvp updatedRsvp) {
         // look for the rsvp in the database
    Optional<Rsvp> existingRsvp = rsvpRepository.findById(id); //using Optional to safely wrap it

    // if not found, return 404
    if (existingRsvp.isEmpty()) {
        return ResponseEntity.notFound().build();
    }

     // get the actual event out of the Optional
    Rsvp rsvp = existingRsvp.get();


    // overwrite the old rsvp status with the new rsvp status
    rsvp.setStatus(updatedRsvp.getStatus());

    // save and return it
    return ResponseEntity.ok(rsvpRepository.save(rsvp));
    }

    //Delete an RSVP - for the User to undo their rsvp to an event 
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRsvp(@PathVariable Long id) {
     if (!rsvpRepository.existsById(id)) {
        return ResponseEntity.notFound().build();
    }
    rsvpRepository.deleteById(id);
    
    return ResponseEntity.noContent().build();
}


}