package com.UniVents.EventsManagement.repository;

import com.UniVents.EventsManagement.entity.Event;
import org.springframework.data.jpa.repository.JpaRepository; //gives us built-in database ops

public interface EventRepository extends JpaRepository<Event, Long> {


    
}