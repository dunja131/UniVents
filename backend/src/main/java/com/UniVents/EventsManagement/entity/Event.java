package com.UniVents.EventsManagement.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "events")
public class Event {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long eventId;

    @Column(name = "event_name", nullable = false)
    private String eventName;

    @Column(name = "price", nullable = false)
    private BigDecimal price;

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
    @JoinColumn(name = "organiser_id", nullable = true) //have made organiser nullable for now so i can test adding a new event in postman and I am currently logged in as student (with token) - will change (kimi 21/04)
    @JsonBackReference
    private Organiser organiser;

    @OneToMany(mappedBy = "event")
    private List<Rsvp> rsvps;


public Long getEventId() {return eventId;}
public String getEventName() {return eventName;}
public BigDecimal getPrice() {return price;}
public String getDescription() {return description;}
public String getLocation() {return location;}
public LocalDateTime getStartTime() {return startTime;}
public LocalDateTime getEndTime() {return endTime;}
public LocalDateTime getCreatedAt() {return createdAt;}
public Organiser getOrganiser() {return organiser;}
public Long getOrganiserId() {return organiser != null ? organiser.getOrganiserId() : null;}

public void setEventName(String eventName) {this.eventName = eventName;}
public void setPrice(BigDecimal price) {this.price = price;} 
public void setDescription(String description) {this.description = description;}
public void setLocation(String location) {this.location = location;}
public void setStartTime(LocalDateTime startTime) {this.startTime = startTime;}
public void setEndTime(LocalDateTime endTime) {this.endTime = endTime;}
public void setCreatedAt(LocalDateTime createdAt) {this.createdAt = createdAt;}


}
