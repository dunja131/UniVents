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

    //POST - create RSVP 

    //GET /rsvps/event/{eventId} - get all RSVPs for an event
    @GetMapping("/event/{eventId}")
    public List<Rsvp> getRsvpsByEvent(@PathVariable Long eventId){
        return rsvpRepository.findByEvent_EventId(eventId);
    }

    //GET - get RSVPs by user - how many rsvps a user has 

    //PUT - update RSVPs going, maybe, not going



}