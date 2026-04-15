import 'package:flutter/material.dart';
import 'dart:convert';

List<Event> eventFromJson(String str) => List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

class Event {
  final String title;
  final String price;
  final DateTime startTime;   
  final DateTime endTime;     
  final String description;
  final String location;
  final String imagePath;
  final Color color;          
  final bool isAllDay;       
  final DateTime createdAt; 
  final int organiserId;

  //final List<String> attendees;

  Event({
    required this.title,
    this.price = "100",
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.location,
    this.imagePath = "lib/images/HydeStreet.jpg",
    this.color = const Color(0xFF2196F3),
    this.isAllDay = false,
    required this.createdAt,
    required this.organiserId,

    //required this.attendees,
  });

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      title: json['event_name'] as String, 
      startTime: DateTime.parse(json['start_time'] as String), 
      endTime: DateTime.parse(json['end_time'] as String), 
      description: json['description'] as String, 
      location: json['location'] as String, 
      createdAt: DateTime.parse(json['created_at'] as String), 
      organiserId: json['organiser_id'] as int,

      //price: json['price'] as String, 
      //imagePath: json['imagePath'] as String, 
      //color: color, 
      //isAllDay: isAllDay
    );
  }
}


//event_name, description, location, start_time, end_time, created_at, organiser_id)