import 'package:flutter/material.dart';
import '../themes/template_theme.dart';

final executiveTheme = ResumeTheme(
  primaryColor: Colors.deepPurple[800]!,
  accentColor: Colors.amber[800]!,
  textColor: Colors.black87,
  dividerColor: Colors.amber[100]!,
  pageMargin: 36.0,
  sectionSpacing: 14.0,
  itemSpacing: 6.0,
  headerTitleStyle: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple[900]!,
  ),
  headerSubtitleStyle: TextStyle(
    fontSize: 13,
    color: Colors.deepPurple[600]!,
  ),
  sectionTitleStyle: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.deepPurple[800]!,
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
