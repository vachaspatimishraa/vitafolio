import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The tabs available in the app shell.
enum NavigationTab { home, templates }

/// State for the app navigation.
class NavigationState {
  final int selectedIndex;
  final NavigationTab currentTab;

  const NavigationState({
    required this.selectedIndex,
    required this.currentTab,
  });

  NavigationState copyWith({int? selectedIndex, NavigationTab? currentTab}) {
    return NavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      currentTab: currentTab ?? this.currentTab,
    );
  }
}

/// View model to manage app shell tab selection.
class NavigationViewModel extends StateNotifier<NavigationState> {
  NavigationViewModel()
    : super(
        const NavigationState(selectedIndex: 0, currentTab: NavigationTab.home),
      );

  /// Changes the active tab index and navigates using [navigationShell].
  void setIndex(int index, StatefulNavigationShell navigationShell) {
    if (state.selectedIndex == index) return;

    final tab = NavigationTab.values[index];
    state = state.copyWith(selectedIndex: index, currentTab: tab);
    navigationShell.goBranch(index);
  }
}

/// Riverpod provider for [NavigationViewModel].
final navigationViewModelProvider =
    StateNotifierProvider<NavigationViewModel, NavigationState>((ref) {
      return NavigationViewModel();
    });
