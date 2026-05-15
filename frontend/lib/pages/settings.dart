import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/home_page.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  final UserService userService;
  const SettingsPage({super.key, required this.userService});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = widget.userService.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user logged in')));
    }

   

return Scaffold(
  backgroundColor: colorScheme.surface,
  body: SettingsList(
    sections: [
      // profile header
      CustomSettingsSection(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 40,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  user.firstName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${user.firstName} ${user.lastName}',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // account section
      SettingsSection(
        title: const Text('Account'),
        tiles: [
          SettingsTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('First Name'),
            value: Text(user.firstName),
          ),
          SettingsTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Last Name'),
            value: Text(user.lastName),
          ),
          SettingsTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            value: Text(user.email),
          ),
          SettingsTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text('Log Out', style: TextStyle(color: colorScheme.error)),
            onPressed: (context) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
          ),
         ],  // ← closes tiles list
      ),    // ← closes SettingsSection
    ],      // ← closes sections list
  ),        // ← closes SettingsList
);
  }
//       // danger zone
//       SettingsSection(
//         title: Text('Danger Zone', style: TextStyle(color: colorScheme.error)),
//         tiles: [
//           SettingsTile(
//             leading: Icon(Icons.delete_outline, color: colorScheme.error),
//             title: Text('Delete Account', style: TextStyle(color: colorScheme.error)),
//             onPressed: (context) => _confirmDelete(context),
//           ),
//         ],
//       ),
//     ],
//   ),
// );
  
  Widget _settingsRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(widget.userService.userId ?? '');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await widget.userService.deleteUser(userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete: $e')),
      );
    }
  }
}