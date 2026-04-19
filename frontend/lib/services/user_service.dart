import 'dart:convert';
import 'package:frontend/models/event_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl = 'http://10.0.2.2:8080';
  final String _username;
  final String _password;
  //final String _auth = 'Basic ${base64.encode(utf8.encode('$_username:$_password'))}';

  UserService(this._username, this._password);

  String get _auth => 'Basic ${base64.encode(utf8.encode('$_username:$_password'))}';
  
  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: <String, String>{'Authorization': _auth},
    );

    if (response.statusCode == 200) {
      return userFromJson(response.body);
    }

    throw Exception('Failed to load users (${response.statusCode})');
  }

  Future<User> login() async {
    //final String _userAuth = 'Basic ${base64.encode(utf8.encode('$email:$password'))}';
    final response = await http.get(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': _auth,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to login (${response.statusCode})');
  }
}



//final response = await http.get(Uri.parse('$_baseUrl/events'), headers: <String, String>{'Authorization': _auth});