import 'dart:convert';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {

  static const String _baseUrl = 'http://10.0.2.2:8080';
  static const String _username = "anna@gmail.com";
  static const String _password = "password";
  static final String _auth = 'Basic ${base64.encode(utf8.encode('$_username:$_password'))}';

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$_baseUrl/events'), headers: <String, String>{'Authorization': _auth});

  if(response.statusCode == 200) {
    return userFromJson(response.body);
  }

  throw Exception('Failed to load users (${response.statusCode})');

  }

  Future<User> login(String email, String password) async{
        final response = await http.get(Uri.parse('$_baseUrl/events'), headers: <String, String>{'Content-Type': 'application/json', 'Authorization': _auth});

  }


}