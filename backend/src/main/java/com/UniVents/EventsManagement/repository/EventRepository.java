package com.UniVents.EventsManagement.repository;

import com.UniVents.EventsManagement.entity.Event;
import org.springframework.data.jpa.repository.JpaRepository; //gives us built-in database ops
import java.util.List;

import com.UniVents.EventsManagement.entity.Organiser;

public interface EventRepository extends JpaRepository<Event, Long> {

    List<Event> findByRsvps_User_UserId(Long userId);

    //springboot maps this as search where category matches passed in category
    List<Event> findByCategoryIgnoreCase(String category); 
    
List<Event> findByEventNameContainingIgnoreCase(String eventName);

List<Event> findByOrganiser(Organiser organiser);
}