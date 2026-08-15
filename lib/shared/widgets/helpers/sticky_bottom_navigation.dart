import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Vitafolio v2.0 Sticky Bottom Navigation Bar reading colors dynamically from ThemeData
class StickyBottomNavigation extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final String secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final bool isPrimaryLoading;

  const StickyBottomNavigation({
    super.key,
    this.primaryLabel = 'Continue →',
    this.onPrimaryPressed,
    this.secondaryLabel = 'Previous',
    this.onSecondaryPressed,
    this.isPrimaryLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
        ),
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
                flex: 1,
                child: OutlinedButton(
                  onPressed: onSecondaryPressed,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    backgroundColor: colorScheme.surface,
                    side: BorderSide(color: colorScheme.outline, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                    ),
                  ),
                  child: Text(
                    secondaryLabel,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: isPrimaryLoading ? null : onPrimaryPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
                  ),
                ),
                child: isPrimaryLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        primaryLabel,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
