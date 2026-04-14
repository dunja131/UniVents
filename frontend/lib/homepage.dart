import 'package:flutter/material.dart';
import 'package:frontend/pages/friends.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/landing.dart';
import 'pages/calander.dart';
import 'pages/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    LandingPage(),
    CalendarPage(), 
    FriendsPage(),
    SettingsPage(),
  ];  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.blueAccent),
        actions: [
          Icon(Icons.logout, color: Colors.blueAccent),
          SizedBox(width: 16),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.transparent,
            color: Colors.blue,
            activeColor: Colors.blue,
            tabBackgroundColor: Colors.blue.withValues(alpha: 0.1),
            padding: EdgeInsets.all(16),
            gap: 8,
            onTabChange: _navigateBottomBar,
            tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.calendar_month,
            text: 'Calendar',
          ),
          GButton(
            icon: Icons.person,
            text: 'Friends',
          ),
          GButton(
            icon: Icons.settings,
            text: 'Settings',
          ),
            ],
          ),
        ),
      ),
    );
  }
}