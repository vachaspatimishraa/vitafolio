import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Sticky Footer Action Bar displaying Cancel and Save buttons with callbacks.
class FooterActionBar extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const FooterActionBar({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
              child: Semantics(
                label: 'Cancel and return to education list',
                button: true,
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                    ),
                    side: BorderSide(color: colorScheme.outline),
                  ),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: SizedBox(
              height: 54,
              child: Semantics(
                label: 'Save education record',
                button: true,
                child: ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
