import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/landing.dart';
import 'pages/calander.dart';
import 'pages/event.dart';
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
    EventPage(),
    SettingsPage(),
  ];

  final List<String> _pageTitles = [
    'Home',
    'Calendar',
    'Friends',
    'Settings',
  ];
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.white),
        actions: [
          Icon(Icons.logout, color: Colors.white),
          SizedBox(width: 16),
        ],
        title: Text(
          _pageTitles[_selectedIndex],
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            icon: Icons.calendar_view_month,
            text: 'Calendar',
          ),
          GButton(
            icon: Icons.message,
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