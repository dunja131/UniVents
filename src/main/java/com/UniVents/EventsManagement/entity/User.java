package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;

@Entity
@Table(name="users")
public class User {
@Id
@GeneratedValue (strategy = GenerationType.IDENTITY) // primary key
@Column (name = "user_id")
private Long userId; 


@Column(name = "first_name", nullable = false, length = 100)
private String firstName;


@Column(name = "last_name", nullable = false, length = 100)
private String lastName;

@Column(name = "email_address", nullable = false, unique = true, length = 100)
private String email; 

@Column(name = "password_hash", nullable = false, columnDefinition = "TEXT")
private String passwordHash;
}