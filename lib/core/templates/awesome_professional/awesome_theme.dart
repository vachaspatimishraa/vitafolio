import 'package:flutter/material.dart';
import '../themes/template_theme.dart';

final awesomeTheme = ResumeTheme(
  primaryColor: Colors.blue[600]!,
  accentColor: Colors.lightBlue[400]!,
  textColor: Colors.black87,
  dividerColor: Colors.lightBlue[100]!,
  pageMargin: 36.0,
  sectionSpacing: 14.0,
  itemSpacing: 6.0,
  headerTitleStyle: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.blue[900]!,
  ),
  headerSubtitleStyle: TextStyle(
    fontSize: 13,
    color: Colors.blueGrey[600]!,
  ),
  sectionTitleStyle: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.blue[800]!,
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
