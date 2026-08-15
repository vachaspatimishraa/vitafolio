import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_colors.dart';
import 'package:vitafolio/core/theme/app_typography.dart';

/// Centralized Material 3 Theme definitions supporting Light and Dark modes.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.lightTextPrimary,
        secondary: AppColors.lightTextSecondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.lightSurface,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        onSurfaceVariant: AppColors.lightTextSecondary,
        outline: AppColors.lightOutline,
        outlineVariant: AppColors.lightBorder,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,

      appBarTheme: const AppBarTheme(
        toolbarHeight: 64,
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary, size: 24),
        actionsIconTheme: IconThemeData(color: AppColors.lightTextPrimary, size: 24),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.lightTextPrimary,
        ),
      ),

      textTheme: AppTypography.getTextTheme(AppColors.lightTextPrimary),

      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.lightBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightBackground,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightOutline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lightOutline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.lightTextSecondary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.lightTextSecondary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: AppColors.lightBackground,
          foregroundColor: AppColors.lightTextPrimary,
          side: const BorderSide(color: AppColors.lightOutline, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        extendedTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        dragHandleColor: AppColors.lightOutline,
        dragHandleSize: Size(48, 5),
        showDragHandle: true,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightSurface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryLight,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFF3B2400),
        onPrimaryContainer: AppColors.darkTextPrimary,
        secondary: AppColors.darkTextSecondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.darkCard,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkBorder,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,

      appBarTheme: const AppBarTheme(
        toolbarHeight: 64,
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.darkTextPrimary, size: 24),
        actionsIconTheme: IconThemeData(color: AppColors.darkTextPrimary, size: 24),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextPrimary,
        ),
      ),

      textTheme: AppTypography.getTextTheme(AppColors.darkTextPrimary),

      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkTextField,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.darkTextSecondary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.darkTextSecondary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: AppColors.darkCard,
          foregroundColor: AppColors.darkTextPrimary,
          side: const BorderSide(color: AppColors.darkBorder, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        extendedTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        dragHandleColor: AppColors.darkBorder,
        dragHandleSize: Size(48, 5),
        showDragHandle: true,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: Color(0xFF3B2400),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkCard,
        contentTextStyle: const TextStyle(color: AppColors.darkTextPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
