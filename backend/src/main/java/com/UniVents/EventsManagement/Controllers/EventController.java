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

import org.springframework.web.bind.annotation.RequestParam;

import com.UniVents.EventsManagement.entity.Organiser;
import com.UniVents.EventsManagement.repository.OrganiserRepository;
import com.UniVents.EventsManagement.Service.JwtUtil;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestHeader;

import com.UniVents.EventsManagement.entity.Rsvp;

@RestController // tells Spring this class handles HTTP requests
@RequestMapping("/events") //
public class EventController {

    private final EventRepository eventRepository; // connects to the database

    private final OrganiserRepository organiserRepository;
    private final JwtUtil jwtUtil;

    public EventController(EventRepository eventRepository,
            OrganiserRepository organiserRepository,
            JwtUtil jwtUtil) {
        this.eventRepository = eventRepository;
        this.organiserRepository = organiserRepository;
        this.jwtUtil = jwtUtil;
    }

    // GET /events - all events
    // updated 12/05 so that it now accepts an optional category as param
    // No category in param = just return everything, otherwise return the filtered
    // category events result
    @GetMapping
    public List<Event> getAllEvents(@RequestParam(required = false) String category) {
        if (category == null || category.isBlank()) {
            return eventRepository.findAll();
        }
        return eventRepository.findByCategoryIgnoreCase(category);
    }

    // GET /events/my - get all events for the logged-in organiser
    @GetMapping("/my")
    public ResponseEntity<List<Event>> getMyEvents(
            @RequestHeader("Authorization") String authHeader) {

        String token = authHeader.replace("Bearer ", "");
        String email = jwtUtil.extractEmail(token);

        Organiser organiser = organiserRepository.findByOrganiserEmail(email)
                .orElseThrow(() -> new RuntimeException("Organiser not found"));

        List<Event> events = eventRepository.findByOrganiser(organiser);
        return ResponseEntity.ok(events);
    }

    // GET /events/search
    @GetMapping("/search")
    public List<Event> searchEvents(@RequestParam String query) {
        return eventRepository.findByEventNameContainingIgnoreCase(query);
    }

    // GET /one event
    @GetMapping("/{id}")
    public ResponseEntity<Event> getEventById(@PathVariable Long id) {
        Optional<Event> event = eventRepository.findById(id);
        return event.map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // GET /events/{id}/attendees - get attendees for an event (organiser)
    @GetMapping("/{id}/attendees")
    public ResponseEntity<List<Rsvp>> getAttendees(@PathVariable Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Event not found"));
        return ResponseEntity.ok(event.getRsvps());
    }

    // GET /events/user/{userId} - get all events user has RSVPd to
    @GetMapping("/user/{userId}")
    public List<Event> getEventsByUser(@PathVariable Long userId) {
        return eventRepository.findByRsvps_User_UserId(userId);
    }

    // POST /events - create event (organiser only)
    @PostMapping
    public ResponseEntity<Event> createEvent(
            @RequestBody Event event,
            @RequestHeader("Authorization") String authHeader) {

        // Extract email from JWT
        String token = authHeader.replace("Bearer ", "");
       String email = jwtUtil.extractEmail(token);

        // Look up the organiser by email and link them to the event
        Organiser organiser = organiserRepository.findByOrganiserEmail(email)
                .orElseThrow(() -> new RuntimeException("Organiser not found"));

        event.setOrganiser(organiser);
        event.setCreatedAt(LocalDateTime.now());

        return ResponseEntity.status(HttpStatus.CREATED).body(eventRepository.save(event));
    }

    // PUT /events/{id} - update event (organisers)
    @PutMapping("/{id}")
    public ResponseEntity<Event> updateEvent(@PathVariable Long id, @RequestBody Event updatedEvent) {
        // look for the event in the database
        Optional<Event> existingEvent = eventRepository.findById(id); // using Optional to safely wrap it

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
    public ResponseEntity<Void> deleteEvent(@PathVariable Long id) {

        if (!eventRepository.existsById(id)) {
            return ResponseEntity.notFound().build(); // return status code with no data
        }
        eventRepository.deleteById(id);
        return ResponseEntity.noContent().build(); // return 204 successful deletion
    }

}
