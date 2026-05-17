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
    final cs = Theme.of(context).colorScheme;
    final user = widget.userService.currentUser;
 
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user logged in')));
    }
 
    return Scaffold(
      backgroundColor: cs.surface,
      body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: SettingsList(
        // ── Match background to theme surface ──
        lightTheme: SettingsThemeData(
          settingsListBackground: cs.surface,
          settingsSectionBackground: cs.surface,
          dividerColor: cs.outlineVariant,
          titleTextColor: cs.onSurfaceVariant,
          leadingIconsColor: cs.onSurfaceVariant,
          tileDescriptionTextColor: cs.onSurfaceVariant,
          settingsTileTextColor: cs.onSurface,
        ),
        sections: [
          // ── Profile header ──
          CustomSettingsSection(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: cs.surfaceContainerHighest,
                      child: Text(
                        user.firstName[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
  
          // ── Account section ──
          SettingsSection(
            title: const Text('Account'),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: const Text('First Name'),
                value: Text(user.firstName),
              ),
              SettingsTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: const Text('Last Name'),
                value: Text(user.lastName),
              ),
              SettingsTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                value: Text(user.email),
              ),
            ],
          ),
 
          // ── Log out section ──
          SettingsSection(
            tiles: [
              SettingsTile(
                leading: Icon(Icons.logout_rounded, color: cs.error),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                    color: cs.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: (context) {
                  widget.userService.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
 
  void confirmDelete(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
            child: Text('Delete', style: TextStyle(color: cs.error)),
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