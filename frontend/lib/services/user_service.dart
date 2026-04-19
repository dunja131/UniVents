import 'dart:convert';
import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;


class UserService {
  static const String _baseUrl = 'http://10.0.2.2:8080';
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
    // Step 1: get JWT token
    final tokenResponse = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': _email, 'password': _password}),
    );

    if (tokenResponse.statusCode != 200) {
      throw Exception('Failed to login (${tokenResponse.statusCode})');
    }

    _token = tokenResponse.body;

    // Step 2: fetch user profile using the token
    final profileResponse = await http.get(
      Uri.parse('$_baseUrl/users/my-profile'),
      headers: {'Authorization': authHeader},
    );

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
    final uri = Uri.parse('$_baseUrl/users/register').replace(queryParameters: {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'password': user.password,
    });
    final response = await http.post(uri);
    if (response.statusCode == 409) {
      throw Exception('An account with that email already exists');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to create user (${response.statusCode})');
    }
  }
}
