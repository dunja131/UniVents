package com.UniVents.EventsManagement.repository;

import com.UniVents.EventsManagement.entity.User;
import org.springframework.data.jpa.repository.JpaRepository; //gives us built-in database ops

public interface UserRepository extends JpaRepository<User, Long> {


    
}