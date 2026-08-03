import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';

final modernTheme = ResumeTheme(
  primaryColor: Colors.blueGrey[800]!,
  accentColor: Colors.blue[700]!,
  textColor: Colors.black87,
  dividerColor: Colors.blueGrey[200]!,
  pageMargin: 36.0,
  sectionSpacing: 14.0,
  itemSpacing: 6.0,
  headerTitleStyle: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey[900]!,
  ),
  headerSubtitleStyle: TextStyle(fontSize: 13, color: Colors.blueGrey[600]!),
  sectionTitleStyle: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.blueGrey[800]!,
  ),
  bodyStyle: const TextStyle(fontSize: 10, color: Colors.black87),
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
