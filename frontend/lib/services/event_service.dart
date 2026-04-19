import 'dart:convert';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;

class EventService {
  // Use 10.0.2.2 for Android emulator, Use 192.168.x.x for physical device, localhost otherwise
  static const String _baseUrl = 'http://10.0.2.2:8080';
  final UserService _userService;

  EventService(this._userService);

  Future<List<Event>> getEvents() async {
    final response = await http.get(Uri.parse('$_baseUrl/events'), headers: <String, String>{'Authorization': _userService.authHeader});

    if(response.statusCode == 200) {
      return eventFromJson(response.body);
    }

    throw Exception('Failed to load events (${response.statusCode})');
  }


  // Get evevnts by user id
  Future<List<Event>> getEventsByUser() async {
    String? userId = _userService.userId;
    final response = await http.get(Uri.parse('$_baseUrl/events/user/$userId'), headers: <String, String>{'Authorization': _userService.authHeader});

    if(response.statusCode == 200) {
      return eventFromJson(response.body);
    }

    throw Exception('Failed to load events (${response.statusCode})');
  }


  // TODO: implement add event 
  void addEvent() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/events'),
      headers: {'Content-Type': 'application/json'},
      // TODO: implement user model to JSON method
      
      //body: jsonEncode({'email': _email, 'password': _password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login (${response.statusCode})');
    }

    throw Exception('Failed to load events (${response.statusCode})');
  }

