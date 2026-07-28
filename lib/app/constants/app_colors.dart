import 'package:flutter/material.dart';

@immutable
abstract final class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF0040A1);
  static const Color background = Color(0xFFFDF8FD);

  // Semantic colors
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFB00020); // Material Error Color
  static const Color info = Color(0xFF0288D1);

  // Light colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color surface = Color(0xFFFFFFFF);

  // Dark colors (if needed for later)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
}
