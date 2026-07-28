import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme getTextTheme(Color textColor) {
    return GoogleFonts.outfitTextTheme(
      TextTheme(
        displayLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: textColor, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
    );
  }
}
