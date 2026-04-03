package com.UniVents.EventsManagement.entity;

import jakarta.persistence.*;

@entity
@table(name="users")
public class User {


@Id
@GeneratedValue (strategy = GenerationType.IDENTITY)
@Column (name = "user_id")
private Long userId; 





}