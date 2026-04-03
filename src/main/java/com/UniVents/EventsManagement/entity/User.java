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





}