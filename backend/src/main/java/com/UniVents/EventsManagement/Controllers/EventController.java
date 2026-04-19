package com.UniVents.EventsManagement.Controllers;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.UniVents.EventsManagement.entity.Event;
import com.UniVents.EventsManagement.repository.EventRepository;


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

//GET /one event
    @GetMapping("/{id}")
    public ResponseEntity<Event> getEventById(@PathVariable Long id){
        Optional<Event> event = eventRepository.findById(id);
        return event.map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Event createEvent(@RequestBody Event event){
        event.setCreatedAt(LocalDateTime.now());
        return eventRepository.save(event);
    }

    // PUT /events/{id} - update event (organisers)
    @PutMapping("/{id}")
    public ResponseEntity<Event> updateEvent(@PathVariable Long id, @RequestBody Event updatedEvent){
        // look for the event in the database
        Optional<Event> existingEvent = eventRepository.findById(id); //using Optional to safely wrap it

        // if not found, return 404
        if (existingEvent.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        // get the actual event out of the Optional
        Event event = existingEvent.get();
        
        // overwrite the old data with the new data
        event.setEventName(updatedEvent.getEventName());
        event.setPrice(updatedEvent.getPrice());
        event.setDescription(updatedEvent.getDescription());
        event.setLocation(updatedEvent.getLocation());
        event.setStartTime(updatedEvent.getStartTime());
        event.setEndTime(updatedEvent.getEndTime());

        // save and return it
        return ResponseEntity.ok(eventRepository.save(event));
}


@DeleteMapping("/{id}")
public ResponseEntity<Void> deleteEvent(@PathVariable Long id){

 if (!eventRepository.existsById(id)) {
        return ResponseEntity.notFound().build(); //return status code with no data
    }
    eventRepository.deleteById(id);
    return ResponseEntity.noContent().build(); //return 204 successful deletion
}



}


