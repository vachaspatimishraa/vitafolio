import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/core/theme/app_theme.dart';
import 'package:vitafolio/core/theme/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Vitafolio',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Router
      routerConfig: AppRouter.router,
    );
  }
}

