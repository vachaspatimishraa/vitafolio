import 'package:flutter/material.dart';

@immutable
abstract final class AppConstants {
  // Animation Durations
  static const Duration splashDuration = Duration(milliseconds: 2000);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration debounceDuration = Duration(milliseconds: 500);

  // Limits
  static const int maxResumeCount = 10;
  static const int defaultPageSize = 10;
  static const int minNameLength = 2;
  static const int maxSummaryLength = 500;
  static const int resumeLimit = 5;

  // Files
  static const String pdfExtension = '.pdf';
  static const String imageExtension = '.png';
}
