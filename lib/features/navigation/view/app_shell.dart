import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_navigation.dart';

/// The main application shell container, providing a persistent bottom navigation bar.
class AppShell extends StatelessWidget {
  /// The navigation shell for the current branch.
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigation(navigationShell: navigationShell),
    );
  }
}
