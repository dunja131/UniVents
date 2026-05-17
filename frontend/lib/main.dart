import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:frontend/pages/welcomePage.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,

          // Primary → black instead of green
          primary: Color(0xFF171C1A),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFF0F0F0),
          onPrimaryContainer: Color(0xFF171C1A),

          // Secondary
          secondary: Color(0xFFEEF1F0),
          onSecondary: Color(0xFF222A26),
          secondaryContainer: Color(0xFFECEEED),
          onSecondaryContainer: Color(0xFF6D7873),

          // Tertiary
          tertiary: Color(0xFF6D7873),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFE9ECEF),
          onTertiaryContainer: Color(0xFF171C1A),

          // Surface
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF171C1A),
          surfaceContainerLowest: Color(0xFFFBFBFB),
          surfaceContainerLow: Color(0xFFF5F5F5),
          surfaceContainer: Color(0xFFECEEED),
          surfaceContainerHigh: Color(0xFFE9ECEF),
          surfaceContainerHighest: Color(0xFFDEE3E0),

          // Variants
          onSurfaceVariant: Color(0xFF6D7873),
          outline: Color(0xFFDEE3E0),
          outlineVariant: Color(0xFFDEE3E0),

          // Error
          error: Color(0xFFDC2828),
          onError: Color(0xFFFFFFFF),
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF93000A),

          // Inverse
          inverseSurface: Color(0xFF171C1A),
          onInverseSurface: Color(0xFFFBFBFB),
          inversePrimary: Color(0xFF6D7873),

          // Scrim
          scrim: Color(0xFF000000),
          shadow: Color(0xFF000000),
        ),
        scaffoldBackgroundColor: const Color(0xFFFBFBFB),
        useMaterial3: true,
        textTheme: GoogleFonts.dmSansTextTheme(),
      ),


      themeMode: ThemeMode.light,
      home: const WelcomePage(),
    );
  }
}
