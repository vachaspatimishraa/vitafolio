import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  void toggleTheme([Brightness? currentBrightness]) {
    if (state == ThemeMode.system) {
      if (currentBrightness != null) {
        state = currentBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
      } else {
        state = ThemeMode.dark;
      }
    } else {
      state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}
