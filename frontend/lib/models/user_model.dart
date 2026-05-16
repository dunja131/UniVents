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

 factory User.fromJson(Map<String, dynamic> json) {
  // handle organiser name — split "New Organiser" into first + last
  final fullName = json['organiserName'] as String? ?? '';
  final nameParts = fullName.split(' ');

  return User(
    userId: (json['userId'] ?? json['organiserId'])?.toString() ?? '',
    firstName: json['firstName'] as String? ?? 
               (nameParts.isNotEmpty ? nameParts.first : ''),
    lastName: json['lastName'] as String? ?? 
              (nameParts.length > 1 ? nameParts.last : ''),
    email: json['email'] as String? ?? 
           json['organiserEmail'] as String? ?? '',
    password: json['passwordHash'] as String? ?? 
              json['organiserPassword'] as String? ?? '',
  );
}

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'passwordHash': password,
  };

}

