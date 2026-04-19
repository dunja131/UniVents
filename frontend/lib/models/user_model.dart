import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;


  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,

  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      userId: json['userId'].toString(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['passwordHash'] as String,
    );
  }

}

