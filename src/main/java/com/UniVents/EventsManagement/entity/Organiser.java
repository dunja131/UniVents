package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "organisers")
public class Organisers {

@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
@Column(name = "organiser_id")
private Long organiserId;

@Column(name = "organiser_name", nullable = false)
private String organiserName;

@Column(name = "organiser_email", nullable = false, unique = true)
private String organiserEmail;
}