import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/constants/app_constants.dart';

/// Represents the possible states of the splash screen.
enum SplashState {
  /// Initial state before startup begins.
  initial,

  /// Loading state during the splash delay.
  loading,

  /// Indicates the splash screen should navigate to home.
  navigateToHome,
}

/// ViewModel for the Splash screen.
///
/// Manages the startup flow: initial -> loading -> navigateToHome.
/// Does not access BuildContext, database, or repositories.
class SplashViewModel extends StateNotifier<SplashState> {
  /// Creates a [SplashViewModel] with the initial state set to [SplashState.initial].
  SplashViewModel() : super(SplashState.initial);

  /// Starts the splash startup flow.
  ///
  /// Transitions to [SplashState.loading], waits for [AppConstants.splashDuration],
  /// then transitions to [SplashState.navigateToHome].
  Future<void> start() async {
    state = SplashState.loading;
    state = SplashState.navigateToHome;
  }
}

/// Riverpod provider for [SplashViewModel].
final splashViewModelProvider =
    StateNotifierProvider<SplashViewModel, SplashState>((ref) {
      return SplashViewModel();
    });
