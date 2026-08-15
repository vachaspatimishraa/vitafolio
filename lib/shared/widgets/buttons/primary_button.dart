import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Vitafolio v2.0 Primary Button sizing naturally based on parent constraints.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool iconTrailing;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.iconTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null && !iconTrailing) ...[
          Icon(icon, size: 20, color: colorScheme.onPrimary),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimary,
          ),
        ),
        if (icon != null && iconTrailing && !isLoading) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(icon, size: 20, color: colorScheme.onPrimary),
        ],
      ],
    );

    final Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        overlayColor: WidgetStateProperty.all(
          colorScheme.primaryContainer.withValues(alpha: 0.2),
        ),
        child: Ink(
          height: 54,
          decoration: BoxDecoration(
            color: onPressed == null
                ? colorScheme.outlineVariant
                : colorScheme.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: buttonContent,
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: label,
      child: button,
    );
  }
}
