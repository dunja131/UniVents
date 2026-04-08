package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonBackReference;

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
    @JsonBackReference
    private Organiser organiser;


   public Long getEventId() {return eventId;}

public String getEventName() {
    return eventName;
}

public String getDescription() {return description;}
public String getLocation() {return location;}
public LocalDateTime getStartTime() {return startTime;}
public LocalDateTime getEndTime() {return endTime;}
public LocalDateTime getCreatedAt() {return createdAt;}
public Organiser getOrganiser() {return organiser;}

}