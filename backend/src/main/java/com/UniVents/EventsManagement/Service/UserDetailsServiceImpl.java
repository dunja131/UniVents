package com.UniVents.EventsManagement.Service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.UniVents.EventsManagement.entity.User;
import com.UniVents.EventsManagement.entity.Organiser;

import com.UniVents.EventsManagement.repository.OrganiserRepository;
import com.UniVents.EventsManagement.repository.UserRepository;

import org.springframework.stereotype.Service;


@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserRepository repo;
    private final OrganiserRepository organiserRepository;


    public UserDetailsServiceImpl(UserRepository repo, OrganiserRepository organiserRepository) {
        this.repo = repo;
        this.organiserRepository = organiserRepository;
    }

@Override
public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
    
    var userOpt = repo.findByEmail(username);
    if (userOpt.isPresent()) {
        User user = userOpt.get(); // changed from throwing exception to checking if null so that it can check for organiser if user is not found.
        return org.springframework.security.core.userdetails.User.builder()
                .username(user.getEmail())
                .password(user.getPasswordHash())
                .roles("USER")
                .build();
    }

    Organiser organiser = organiserRepository.findByOrganiserEmail(username)
            .orElseThrow(() -> new UsernameNotFoundException("User or Organiser not found"));

    return org.springframework.security.core.userdetails.User.builder()
            .username(organiser.getOrganiserEmail())
            .password(organiser.getOrganiserPassword())
            .roles("ORGANISER")
            .build();
}
 
    }

