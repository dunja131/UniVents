import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/theme/app_colours.dart';

class SettingsPage extends StatefulWidget {
  final UserService userService;
  const SettingsPage({super.key, required this.userService});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    final user = widget.userService.currentUser;
    final textTheme = Theme.of(context).textTheme;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user logged in')));
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          // first name
          Row(
            children: [
              Text(
                'First Name: ',
                style: textTheme.bodyLarge,
              ),
              Text(
                user.firstName,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColours.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // second name
          Row(),

          // email
          Row(),

          // password
          Row(),
        ],
      ),
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await widget.userService.deleteUser(userId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }
}