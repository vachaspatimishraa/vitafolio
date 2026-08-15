import 'package:flutter/material.dart';
import 'package:vitafolio/core/widgets/app_logo.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/constants/app_strings.dart';

/// Displays the Vitafolio logo, app name, and tagline matching the Stitch Splash design.
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Container
        const SizedBox(
          width: 96,
          height: 96,
          child: AppLogo(width: 96, height: 96),
        ),
        const SizedBox(height: AppSpacing.lg),
        // App Name
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Tagline
        Text(
          AppStrings.appTagline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

