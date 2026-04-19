import 'dart:convert';
import 'package:frontend/models/event_model.dart';
import 'package:http/http.dart' as http;

class EventService {
  // Use 10.0.2.2 for Android emulator, Use 192.168.x.x for physical device, localhost otherwise
  static const String _baseUrl = 'http://10.0.2.2:8080';
  static const String _username = "jack@gmail.com";
  static const String _password = "password";
  static final String _auth = 'Basic ${base64.encode(utf8.encode('$_username:$_password'))}';
  

  Future<List<Event>> getEvents() async {
    final response = await http.get(Uri.parse('$_baseUrl/events'), headers: <String, String>{'Authorization': _auth});

    if(response.statusCode == 200) {
      return eventFromJson(response.body);
    }

    throw Exception('Failed to load events (${response.statusCode})');
  }
}


//    /