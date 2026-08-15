import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vitafolio/features/splash/view_model/splash_view_model.dart';
import 'package:vitafolio/features/splash/widgets/loading_bar.dart';
import 'package:vitafolio/features/splash/widgets/splash_logo.dart';

/// Splash screen displayed on app launch matching Stitch Vitafolio Splash Screen design.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashViewModelProvider);

    ref.listen(splashViewModelProvider, (_, next) {
      if (next == SplashState.navigateToHome) {
        context.goNamed('home');
      }
    });

    if (splashState == SplashState.initial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(splashViewModelProvider.notifier).start();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Center Logo & Typography
            const Center(
              child: SplashLogo(),
            ),
            // Bottom Loading Progress Bar
            Positioned(
              bottom: 64,
              left: 0,
              right: 0,
              child: Center(
                child: splashState == SplashState.loading
                    ? const LoadingBar()
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

