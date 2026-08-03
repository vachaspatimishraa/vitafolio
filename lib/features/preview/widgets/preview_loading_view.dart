import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/shared/widgets/loaders/loading_indicator.dart';

class PreviewLoadingView extends StatelessWidget {
  const PreviewLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: AspectRatio(
        aspectRatio: 1 / 1.414,
        child: Card(
          color: colorScheme.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadingIndicator(),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Loading Preview...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
