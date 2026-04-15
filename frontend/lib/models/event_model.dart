import 'package:flutter/material.dart';

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
  //final List<String> attendees;
  Event({
    required this.title,
    required this.price,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.location,
    required this.imagePath,
    required this.color,
    required this.isAllDay,
    //required this.attendees,
  });
}


