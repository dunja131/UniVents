import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User {
  final String userId;
  final String firstName;
  final String lastNight;
  final String email;
  final String password;


  User({
    required this.userId,
    required this.firstName,
    required this.lastNight,
    required this.email,
    required this.password,

  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastNight: json['last_name'] as String,
      email: json['email_address'] as String,
      password: json['password_hash'] as String,
    );
  }

}

