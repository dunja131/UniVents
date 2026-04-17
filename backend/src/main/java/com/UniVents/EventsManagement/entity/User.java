package com.UniVents.EventsManagement.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.persistence.Enumerated; 

@Entity
@Table(name="users")
public class User {
@Id
@GeneratedValue (strategy = GenerationType.IDENTITY) // primary key
@Column (name = "user_id")
private Long userId; 

/** Separate roles between students and organisers */
public enum Role{
STUDENT, ORGANISER
}

@Enumerated(EnumType.STRING)
@Column(name = "role", nullable = true) //setting to true to allow db to create role
private Role role = Role.STUDENT; //currently defaulting to student

@Column(name = "first_name", nullable = false, length = 100)
private String firstName;


@Column(name = "last_name", nullable = false, length = 100)
private String lastName;

@Email
@NotBlank
@Column(name = "email_address", nullable = false, unique = true, length = 100)
private String email; 

@NotBlank
@Column(name = "password_hash", nullable = false, columnDefinition = "TEXT")
private String passwordHash;

//Getters
    public Long getUserId() { return userId; }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }
    public String getEmail() { return email; }
    public String getPasswordHash() { return passwordHash; }
    public Role getRole() { return role; }

//Setters
    public void setUserId(Long userId) { this.userId = userId; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public void setEmail(String email) { this.email = email; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public void setRole(Role role) { this.role = role; }
}