import 'package:flutter/material.dart';
import 'dart:convert';



List<Event> eventFromJson(String str) => List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

class Event {
  final String title;
  final double price;
  final DateTime startTime;   
  final DateTime endTime;     
  final String description;
  final String location;
  final String imagePath;
  final Color color;          
  final bool isAllDay;       
  final DateTime createdAt; 

  //final int organiserId;
  //final List<String> attendees;

  Event({
    required this.title,
    required this.price,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.location,
    this.imagePath = "lib/images/HydeStreet.jpg",
    this.color = const Color(0xFF2196F3),
    this.isAllDay = false,
    required this.createdAt,

    //required this.organiserId,
    //required this.attendees,
  });

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
      title: json['eventName'] as String, 
      price: (json['price'] as num).toDouble(),
      startTime: _parseDateTime(json['startTime']), 
      endTime: _parseDateTime(json['endTime']), 
      description: json['description'] as String, 
      location: json['location'] as String, 
      createdAt: _parseDateTime(json['createdAt']), 

      //organiserId: json['organiser_id'] as int,
      //price: json['price'] as String, 
      //imagePath: json['imagePath'] as String, 
      //color: color, 
      //isAllDay: isAllDay
    );
  }

  Map<String, dynamic> toJson() => {
    'eventName': title,
    'price': price,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'description': description,
    'location': location,
  };

  static DateTime _parseDateTime(dynamic value) {
    if (value is List) {
      return DateTime(value[0], value[1], value[2], value[3], value.length > 4 ? value[4] : 0);
    }
    return DateTime.parse(value as String);
}
}
