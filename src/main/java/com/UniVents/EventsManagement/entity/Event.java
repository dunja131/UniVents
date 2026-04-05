package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "events")
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long eventId;

    @Column(name = "event_name", nullable = false)
    private String eventName;

   @Column(name = "description", nullable = false)
    private String description;

   @Column(name = "location", nullable = false) 
    private String location; 

    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalDateTime endTime;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @ManyToOne //links many events to one organiser 
    @JoinColumn(name = "organiser_id", nullable = false)
    private Organiser organiser;





}