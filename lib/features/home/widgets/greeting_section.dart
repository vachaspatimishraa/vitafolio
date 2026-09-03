import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/widgets/app_logo.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/core/theme/theme_provider.dart';

class GreetingSection extends ConsumerWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          // Logo Icon Container
          const AppLogo(width: 48, height: 48, fit: BoxFit.contain),
          const SizedBox(width: AppSpacing.md),
          // App Title & Tagline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vitafolio',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    height: 1.1,
                    letterSpacing: -0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Build Professional Resumes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Dark / Light Mode Toggle Button in top right corner
          IconButton.filledTonal(
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme(theme.brightness);
            },
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20,
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              foregroundColor: theme.colorScheme.onSurfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
