import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vitafolio/app/constants/app_colors.dart';

class AppTypography {
  static TextTheme getTextTheme([Color textColor = AppColors.textPrimary]) {
    final baseTextTheme = TextTheme(
      // Display: 32 Bold
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.2,
      ),
      // Screen Title: 28 Bold
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textColor,
        height: 1.25,
      ),
      // Section Title: 22 SemiBold
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      // Card Title: 18 SemiBold
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.35,
      ),
      // Body: 16 Regular
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      // Caption: 14 Regular
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.4,
      ),
      // Small: 12 Regular
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
    );

    return GoogleFonts.interTextTheme(baseTextTheme);
  }
}

