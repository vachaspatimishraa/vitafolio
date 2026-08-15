import 'package:flutter/material.dart';

@immutable
abstract final class AppSpacing {
  // 8pt Grid Spacing / Padding / Margin
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double extraHuge = 48.0;
  static const double massive = 64.0;

  // Design System v2.0 Border Radii
  static const double radiusCard = 16.0;
  static const double radiusButton = 14.0;
  static const double radiusTextField = 14.0;
  static const double radiusDialog = 20.0;
  static const double radiusBottomSheet = 28.0;
  static const double radiusChip = 100.0;

  // Legacy radius aliases
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 28.0;

  // Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 28.0;
  static const double iconXl = 32.0;
}


