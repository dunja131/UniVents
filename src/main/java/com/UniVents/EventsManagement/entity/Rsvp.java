package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "rsvps")
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

}