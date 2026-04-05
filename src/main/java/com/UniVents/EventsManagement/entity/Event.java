package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "events")
public class Events {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    
}