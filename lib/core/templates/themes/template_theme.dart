import 'package:flutter/material.dart';

class ResumeTheme {
  final Color primaryColor;
  final Color accentColor;
  final Color textColor;
  final Color dividerColor;

  final double pageMargin;
  final double sectionSpacing;
  final double itemSpacing;

  final TextStyle headerTitleStyle;
  final TextStyle headerSubtitleStyle;
  final TextStyle sectionTitleStyle;
  final TextStyle bodyStyle;
  final TextStyle italicStyle;
  final TextStyle boldStyle;

  const ResumeTheme({
    required this.primaryColor,
    required this.accentColor,
    required this.textColor,
    required this.dividerColor,
    required this.pageMargin,
    required this.sectionSpacing,
    required this.itemSpacing,
    required this.headerTitleStyle,
    required this.headerSubtitleStyle,
    required this.sectionTitleStyle,
    required this.bodyStyle,
    required this.italicStyle,
    required this.boldStyle,
  });
}
