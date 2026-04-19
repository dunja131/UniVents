import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/home_page.dart';

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
                "First Name",
                selectionColor: Colors.blueAccent,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                user.firstName,
                selectionColor: Colors.blueAccent,
                style: TextStyle(
                  fontSize: 20,
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
        SnackBar(content: Text('Failed to delete user successfully: $e')),
      );
    }
  }
}



// body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         child: ElevatedButton(
//           onPressed: () => _deleteUser(user.userId),
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           child: const Text('Delete User'),
//         ),
//       ),



// TextFormField(
//             controller: _emailController,
//             decoration: const InputDecoration(
//               labelText: 'Email',
//               icon: Icon(Icons.email_outlined),
//             ),
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Email is required';
//               }
//               if (!value.contains('@')) {
//                 return 'Enter a valid email';
//               }
//               return null;
//             },
//           ),