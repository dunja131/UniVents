package com.UniVents.EventsManagement.Controllers;

import com.UniVents.EventsManagement.entity.Event;
import com.UniVents.EventsManagement.repository.EventRepository;


import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;


@RestController  // tells Spring this class handles HTTP requests
@RequestMapping("/events") //
public class EventController{

@Autowired 
private EventRepository eventRepository; //connects to the database

    // GET /events - all events 
    @GetMapping
    public List<Event> getAllEvents() {
    return eventRepository.findAll();
    }

//GET /event
    @GetMapping("/{id}")
    public ResponseEntity<Event> getEventById(@PathVariable Long id){
        Optional<Event> event = eventRepository.findById(id);
        return event.map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Event createEvent(@RequestBody Event event){
        return eventRepository.save(event);
    }

//what i need to add
//- get one event
//-create event - for organisers
// update events - for organisers 
// delete an event = for organisers
}