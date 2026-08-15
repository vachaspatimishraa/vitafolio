import 'package:flutter/material.dart';

/// Vitafolio Global Color Tokens (Light & Dark Mode Support)
@immutable
abstract final class AppColors {
  // Primary Gold Family
  static const Color primary = Color(0xFFE8A024);
  static const Color primaryDark = Color(0xFFC98312);
  static const Color primaryLight = Color(0xFFFFF4D6);
  static const Color primaryContainer = Color(0xFFFFF4D6);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF111827);

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightOutline = Color(0xFFD1D5DB);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF1F2937);
  static const Color darkTextField = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF374151);

  // Legacy Alias Tokens
  static const Color secondary = Color(0xFF6B7280);
  static const Color secondaryContainer = Color(0xFFFAFAFA);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color tertiary = Color(0xFF6B7280);
  static const Color onTertiary = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFAFAFA);
  static const Color surfaceContainer = Color(0xFFFAFAFA);
  static const Color surfaceContainerHigh = Color(0xFFF3F4F6);
  static const Color surfaceContainerHighest = Color(0xFFE5E7EB);

  static const Color inverseSurface = Color(0xFF111827);
  static const Color inverseOnSurface = Color(0xFFFAFAFA);
  static const Color inversePrimary = Color(0xFFE8A024);

  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color onSurface = Color(0xFF111827);
  static const Color onSurfaceVariant = Color(0xFF6B7280);

  static const Color border = Color(0xFFE5E7EB);
  static const Color outline = Color(0xFFD1D5DB);
  static const Color outlineVariant = Color(0xFFE5E7EB);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFFEF4444);
}
