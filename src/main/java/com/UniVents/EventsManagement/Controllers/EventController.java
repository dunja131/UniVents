package com.UniVents.EventsManagement.Controllers;

import com.UniVents.EventsManagement.entity.Event;
import com.UniVents.EventsManagement.repository.EventRepository;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


@RestController  // tells Spring this class handles HTTP requests
@RequestMapping("/events") //
public class EventController{

@Autowired 
private EventRepository eventRepository; //connects to the database


    @GetMapping
    public List<Event> getAllEvents() {
    return eventRepository.findAll();
    }

//what i need to add
//- get one event
//-create event - for organisers
// update events - for organisers
// delete an event = for organisers
}