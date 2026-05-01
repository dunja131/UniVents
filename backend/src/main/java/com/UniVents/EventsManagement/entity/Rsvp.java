package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "rsvps", uniqueConstraints = { @UniqueConstraint(columnNames = {"user_id", "event_id"}) //this is to ensure one RSVP per user per event
})
public class Rsvp{

@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "rsvp_id")
private Long rsvpId;

@ManyToOne //many RSVPs belong to One User
@JoinColumn(name = "user_id", nullable=false)
private User user;

@ManyToOne //many RSVPs belong to One Event
@JoinColumn(name = "event_id", nullable = false)
private Event event;

@Column(name = "status", nullable = false)
private String status;

public Long getRsvpId() {return rsvpId;}
public User getUser() {return user;}
public Event getEvent() {return event;}
public String getStatus() {return status;}


public void setStatus(String status) {this.status = status;}
public void setUser(User user) { this.user = user; }
public void setEvent(Event event) { this.event = event; } 

}