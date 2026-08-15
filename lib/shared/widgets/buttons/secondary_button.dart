import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Vitafolio v2.0 Secondary Button sizing naturally based on parent constraints.
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: colorScheme.onSurface),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );

    final Widget button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 54),
        backgroundColor: colorScheme.surface,
        side: BorderSide(color: colorScheme.outline, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusButton),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      ),
      child: buttonContent,
    );

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: button,
    );
  }
}
