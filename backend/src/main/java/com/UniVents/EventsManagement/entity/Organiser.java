package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonManagedReference;



@Entity
@Table(name = "organisers")
public class Organiser {

public enum Role{
STUDENT, ORGANISER
}

@Enumerated(EnumType.STRING)
@Column(name = "role", nullable = true) //setting to true to allow db to create role
private Role role = Role.ORGANISER; //currently defaulting to organiser


@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "organiser_id")
private Long organiserId;

@Column(name = "organiser_name", nullable = false)
private String organiserName;

@Column(name = "organiser_email", nullable = false, unique = true)
private String organiserEmail;

@OneToMany(mappedBy = "organiser")
@JsonManagedReference
private List<Event> events;

@Column(name = "organiser_password", nullable = false)
private String organiserPassword;

public Organiser() {}

public Long getOrganiserId() {return organiserId;}
public String getOrganiserName() {return organiserName;}
public String getOrganiserEmail() {return organiserEmail;}
public List<Event> getEvents() {return events;}
public String getOrganiserPassword() { return organiserPassword; }
public Role getRole() { return role; }


public void setOrganiserName(String organiserName) {this.organiserName = organiserName;}
public void setOrganiserEmail(String organiserEmail) {this.organiserEmail = organiserEmail;}
public void setOrganiserPassword(String organiserPassword) { this.organiserPassword = organiserPassword; }
public void setRole(Role role) { this.role = role; }

}