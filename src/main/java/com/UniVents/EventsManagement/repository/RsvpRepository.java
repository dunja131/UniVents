package com.UniVents.EventsManagement.repository;

import com.UniVents.EventsManagement.entity.Rsvp;
import org.springframework.data.jpa.repository.JpaRepository; //gives us built-in database ops

import java.util.List;

public interface RsvpRepository extends JpaRepository<Rsvp, Long> {

    List<Rsvp> findByEvent_EventId(Long eventId);

    List<Rsvp> findByUser_UserId(Long userId);
}
    
}