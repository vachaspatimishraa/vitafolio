import 'package:flutter/material.dart';

enum AppIconButtonVariant { standard, filled, tonal, outlined }

/// A premium Material 3 Icon Button wrapper supporting multiple style variants.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final AppIconButtonVariant variant;
  final Color? color;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.tooltip,
    this.variant = AppIconButtonVariant.standard,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Widget button;
    switch (variant) {
      case AppIconButtonVariant.filled:
        button = IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
        );
        break;
      case AppIconButtonVariant.tonal:
        button = IconButton.filledTonal(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
        );
        break;
      case AppIconButtonVariant.outlined:
        button = IconButton.outlined(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
        );
        break;
      case AppIconButtonVariant.standard:
        button = IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color),
        );
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: tooltip,
        child: button,
      ),
    );
  }
}
