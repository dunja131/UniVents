import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colours.dart';

class AppTextStyles {
  static final heading = GoogleFonts.poppins(
    fontSize: 24, fontWeight: FontWeight.bold, color: AppColours.textPrimary,
  );
  static final subheading = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: AppColours.textPrimary,
  );
  static final body = GoogleFonts.poppins(
    fontSize: 14, color: AppColours.textSecondary,
  );
  static final label = GoogleFonts.poppins(
    fontSize: 12, color: AppColours.textSecondary,
  );
}