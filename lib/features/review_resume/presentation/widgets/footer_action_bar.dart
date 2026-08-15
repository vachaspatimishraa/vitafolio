import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Sticky Footer Action Bar exposing Previous and Generate Resume callbacks.
class FooterActionBar extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onGenerate;
  final bool isGenerateEnabled;

  const FooterActionBar({
    super.key,
    required this.onPrevious,
    required this.onGenerate,
    this.isGenerateEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: OutlinedButton(
                    onPressed: onPrevious,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                    child: Text(
                      'Previous',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isGenerateEnabled ? onGenerate : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Generate Resume',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Icon(
                          Icons.picture_as_pdf,
                          size: 16,
                          color: colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
