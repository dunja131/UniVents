import 'package:flutter/material.dart';
import 'package:frontend/services/user_service.dart';
import 'package:frontend/theme/app_colours.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/landing.dart';
import 'pages/calendar.dart';
import 'pages/settings.dart';
import 'pages/optionPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserService? userService;
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // if not logged in, show login page as the first screen
    if (userService == null) {
      return OptionPage(
        onLogin: (service) {
          setState(() {
            userService = service;
            _selectedIndex = 0;
          });
        },
      );

    }
  
    // only shown after the user logs in
    final List<Widget> pages = [
      LandingPage(userService: userService!),
      CalendarPage(userService: userService!),
      SettingsPage(userService: userService!),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 5,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: GNav(
          color: AppColours.primary,
          activeColor: AppColours.primary,
          tabBackgroundColor: AppColours.primary.withValues(alpha: 0.1),
          padding: const EdgeInsets.all(16),
          gap: 8,
          onTabChange: _navigateBottomBar,
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.calendar_month, text: 'Calendar'),
            GButton(icon: Icons.settings, text: 'Settings'),
          ],
        ),
      ),
    );
  }
}