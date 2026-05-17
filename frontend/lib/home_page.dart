import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/landing.dart';
import 'pages/calendar.dart';
import 'pages/settings.dart';
import 'pages/welcomePage.dart';

class HomePage extends StatefulWidget {
  final UserService? initialUserService; // ← accept userService
  const HomePage({super.key, this.initialUserService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserService? userService;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    userService = widget.initialUserService; // ← set from parameter
  }

  void _navigateBottomBar(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // if not logged in, go back to welcome screen
    if (userService == null) {
      return const WelcomePage();
    }

    final List<Widget> pages = [
      LandingPage(userService: userService!),
      CalendarPage(userService: userService!),
      SettingsPage(userService: userService!),
    ];

    return Scaffold(
      appBar: AppBar(centerTitle: true, toolbarHeight: 5),
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GNav(
            color: colorScheme.onSurfaceVariant,
            activeColor: colorScheme.primary,
            tabBackgroundColor: colorScheme.primary.withValues(alpha: 0.1),
            padding: const EdgeInsets.all(14),
            gap: 8,
            duration: const Duration(milliseconds: 300),
            onTabChange: _navigateBottomBar,
            tabs: const [
              GButton(icon: Icons.home_rounded, text: 'Home'),
              GButton(icon: Icons.calendar_month_rounded, text: 'Calendar'),
              GButton(icon: Icons.settings_rounded, text: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}