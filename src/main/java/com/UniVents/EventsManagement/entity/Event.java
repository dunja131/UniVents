package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "events")
public class Events {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long eventId;

    @Column(name = "event_name", nullable = false)
    private String eventName;

   @Column(name = "description", nullable = false)
    private String description;

   @Column(name = "location", nullable = false) 
    private String location; 

    private LocalDateTime startTime;

    private LocalDateTime endTime;

    private LocalDateTime createdAt;


}