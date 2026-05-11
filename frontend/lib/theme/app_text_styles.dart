import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colours.dart';

class AppTextStyles {

  static final logo = GoogleFonts.outfit(
    fontSize: 52,
    fontWeight: FontWeight.w700,
    color: Colors.black87,
    letterSpacing: 1,
  );

  static final heading = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColours.textPrimary,
  );

  static final subheading = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColours.textPrimary,
  );

  static final body = GoogleFonts.inter(
    fontSize: 14,
    color: AppColours.textSecondary,
  );

  static final label = GoogleFonts.inter(
    fontSize: 12,
    color: AppColours.textSecondary,
  );
}