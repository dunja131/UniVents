package com.UniVents.EventsManagement.repository;

import com.UniVents.EventsManagement.entity.Organiser;
import org.springframework.data.jpa.repository.JpaRepository; //gives us built-in database ops

public interface OrganiserRepository extends JpaRepository<Organiser, Long> {


    
}