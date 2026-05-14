import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static const String _baseUrl =
      'http://localhost:8080'; //'http://10.0.2.2:8080';
  final String _email;
  final String _password;
  User? _currentUser;
  String? _token;

  User? get currentUser => _currentUser;

  UserService(this._email, this._password);

  //String get _auth => 'Basic ${base64.encode(utf8.encode('$_username:$_password'))}';

  String get authHeader => 'Bearer $_token';

  String? get userId => _currentUser?.userId;

  Future<List<User>> getUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: {'Authorization': authHeader},
    );

    if (response.statusCode == 200) {
      return userFromJson(response.body);
    }
    throw Exception('Failed to load users (${response.statusCode})');
  }

  Future<User> login() async {
    final tokenResponse = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _email, 'password': _password}),
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception('Failed to login (${tokenResponse.statusCode})');
    }

    //this reads the token and role received by backend when attempting to login
    final body = jsonDecode(tokenResponse.body);
    _token = body['token'];
    final role = body['role'];

    //this determines whether the person logging in is considered organiser otherwise general user
    // and calls the correct profile endpoint based on the role
    final profileUrl = role == 'ROLE_ORGANISER'
        ? '$_baseUrl/organisers/my-profile'
        : '$_baseUrl/users/my-profile';

    // then it fetches the user profile based on the role and token allocated to it
    //lets spring security know who is making the request
    final profileResponse = await http.get(
      Uri.parse(profileUrl),
      headers: {'Authorization': authHeader},
    );

    debugPrint('Profile response: ${profileResponse.statusCode}');
    debugPrint('Profile body: ${profileResponse.body}');

    if (profileResponse.statusCode == 200) {
      _currentUser = User.fromJson(jsonDecode(profileResponse.body));
      return _currentUser!;
    }
    throw Exception('Failed to fetch profile (${profileResponse.statusCode})');
  }

  // Needs {id} in url
  Future<User> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/users'),
      headers: <String, String>{'Authorization': authHeader},
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load users (${response.statusCode})');
  }

  Future<void> createUser(User user) async {
    final uri = Uri.parse('$_baseUrl/users/register').replace(
      queryParameters: {
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
        'password': user.password,
      },
    );
    final response = await http.post(uri);
    if (response.statusCode == 409) {
      throw Exception('An account with that email already exists');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to create user (${response.statusCode})');
    }
  }
}
