package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "organisers")
public class Organiser {

@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "organiser_id")
private Long organiserId;

@Column(name = "organiser_name", nullable = false)
private String organiserName;

@Column(name = "organiser_email", nullable = false, unique = true)
private String organiserEmail;

@OneToMany(mappedBy = "organiser")
private List<Event> events;

public Long getOrganiserId() {return organiserId;}
public String getOrganiserName() {return organiserName;}
public String getOrganisersEmail() {return organiserEmail;}
public List<Event> getEvents() {return events;}
}