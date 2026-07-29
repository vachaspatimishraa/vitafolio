import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view_model/navigation_view_model.dart';

/// Bottom navigation bar using Material 3 style and integrating with [GoRouter] and [Riverpod].
class BottomNavigation extends ConsumerWidget {
  /// The navigation shell containing the routes.
  final StatefulNavigationShell navigationShell;

  const BottomNavigation({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationViewModelProvider);

    return NavigationBar(
      selectedIndex: navState.selectedIndex,
      onDestinationSelected: (index) {
        ref
            .read(navigationViewModelProvider.notifier)
            .setIndex(index, navigationShell);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.edit_note_outlined),
          selectedIcon: Icon(Icons.edit_note),
          label: 'Edit Details',
        ),
        NavigationDestination(
          icon: Icon(Icons.dashboard_customize_outlined),
          selectedIcon: Icon(Icons.dashboard_customize),
          label: 'Templates',
        ),
      ],
    );
  }
}
