import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// A premium Material 3 Primary Filled Button.
/// Supports loading states, custom icons, full width, and responsive padding.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final bool iconTrailing;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.iconTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null && !iconTrailing) ...[
          Icon(icon, size: 18),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: onPressed == null
                ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                : theme.colorScheme.onPrimary,
          ),
        ),
        if (icon != null && iconTrailing && !isLoading) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(icon, size: 18),
        ],
      ],
    );

    final Widget button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      child: isFullWidth
          ? SizedBox(width: double.infinity, child: buttonContent)
          : buttonContent,
    );

    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: label,
      child: button,
    );
  }
}
