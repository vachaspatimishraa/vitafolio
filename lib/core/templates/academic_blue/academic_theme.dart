import 'package:flutter/material.dart';
import '../themes/template_theme.dart';

final academicTheme = ResumeTheme(
  primaryColor: const Color(0xFF00199E),
  accentColor: const Color(0xFF2EC1E0),
  textColor: Colors.black87,
  dividerColor: const Color(0xFF00199E).withValues(alpha: 0.2),
  pageMargin: 40.0,
  sectionSpacing: 16.0,
  itemSpacing: 8.0,
  headerTitleStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF00199E),
  ),
  headerSubtitleStyle: const TextStyle(
    fontSize: 14,
    color: Colors.black54,
  ),
  sectionTitleStyle: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFF00199E),
  ),
  bodyStyle: const TextStyle(
    fontSize: 10,
    color: Colors.black87,
  ),
  italicStyle: const TextStyle(
    fontSize: 10,
    fontStyle: FontStyle.italic,
    color: Colors.black87,
  ),
  boldStyle: const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
);
