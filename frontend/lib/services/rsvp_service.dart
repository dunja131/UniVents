//I am starting the process of allowing the user to interact with + button to rsvp to an event of their choosing
//rsvp_service sits between flutter and the backend Springboot for RSVPs 
//when user presses the + button, rsvp_service sends the message to springboot backend then saved into Database 


import 'dart:convert'; //converts Dart objects to JSON
import 'package:frontend/services/user_service.dart'; //this gets the logged in user information
import 'package:http/http.dart' as http; //allows us to make HTTP requests 

class RsvpService {
   static const String _baseUrl = 'http://localhost:8080/api/rsvps'; //backend address

  final UserService _userService; //userService provides us with the logged in user's details (token, ID)

  RsvpService(this._userService); //constructor 

  //Method which creates RSVP
  Future<void> createRsvp({
    required int eventId, // which event they are RSVPing to
    required String status, // "GOING", "MAYBE", "NOT_GOING"
  }) async {
    
    //this is sending the POST JSON to backend 
    final response = await http.post(
     Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': _userService.authHeader,
      },
      body: jsonEncode({
        "user": {"userId": _userService.userId},
        "event": {"eventId": eventId},
        "status": status,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to RSVP (${response.statusCode})');
    }
  }
}