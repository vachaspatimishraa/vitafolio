import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/constants/app_spacing.dart';
import '../view_model/splash_view_model.dart';
import '../widgets/loading_bar.dart';
import '../widgets/splash_logo.dart';

/// Splash screen displayed on app launch.
///
/// Observes the [SplashViewModel] state and navigates to Home
/// when the startup flow completes.
/// Contains no business logic, timers, or database access.
class SplashScreen extends ConsumerWidget {
  /// Creates a [SplashScreen].
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashViewModelProvider);

    // Listen for navigation event to navigate to Home.
    // This keeps the ViewModel independent of BuildContext.
    ref.listen(splashViewModelProvider, (_, next) {
      if (next == SplashState.navigateToHome) {
        context.goNamed('home');
      }
    });

    // Start the splash flow only if not already started.
    // Guarding with initial state prevents multiple invocations on rebuilds.
    if (splashState == SplashState.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(splashViewModelProvider.notifier).start();
      });
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SplashLogo(),
              SizedBox(height: AppSpacing.huge),
              if (splashState == SplashState.loading) const LoadingBar(),
            ],
          ),
        ),
      ),
    );
  }
}
