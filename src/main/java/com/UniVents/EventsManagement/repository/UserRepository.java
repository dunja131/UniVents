package com.UniVents.EventsManagement.repository;

import org.springframework.data.jpa.repository.JpaRepository; //gives us built-in database ops

import com.UniVents.EventsManagement.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);
}