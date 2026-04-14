package com.UniVents.EventsManagement.repository;

import org.springframework.data.jpa.repository.JpaRepository; //gives us built-in database ops
import java.util.Optional;
import com.UniVents.EventsManagement.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
  Optional<User> findByEmail(String email);
}