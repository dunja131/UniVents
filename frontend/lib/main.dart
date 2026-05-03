import 'package:flutter/material.dart';
import 'package:frontend/theme/app_theme.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UniVents',
      theme: AppTheme.theme,
      home: HomePage(),
    );
  }
}