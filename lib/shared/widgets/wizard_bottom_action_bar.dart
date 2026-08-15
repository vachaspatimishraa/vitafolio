import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Standardized Wizard Bottom Action Bar featuring Save & Continue and Previous buttons.
class WizardBottomActionBar extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final String secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final bool isLoading;

  const WizardBottomActionBar({
    super.key,
    this.primaryLabel = 'Continue',
    this.onPrimaryPressed,
    this.secondaryLabel = 'Previous',
    this.onSecondaryPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (onSecondaryPressed != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : onSecondaryPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    side: BorderSide(color: colorScheme.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 20,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          secondaryLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: FilledButton(
                onPressed: isLoading ? null : onPrimaryPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              primaryLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: colorScheme.onPrimary,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
