package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "organisers")
public class Organisers {

@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "organiser_id")
private Long organiserId;


private Long organiserName;

private Long organiserEmail;




}