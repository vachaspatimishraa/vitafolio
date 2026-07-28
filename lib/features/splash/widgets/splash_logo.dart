import 'package:flutter/material.dart';

import '../../../core/widgets/app_logo.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';

/// Displays the Vitafolio logo, app name, and tagline.
///
/// This widget is purely presentational and contains no business logic.
class SplashLogo extends StatelessWidget {
  /// Creates a [SplashLogo].
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppLogo(
          width: 140,
          height: 140,
        ),
        SizedBox(height: AppSpacing.lg),
        // App Name
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        // Tagline
        Text(
          AppStrings.appTagline,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
