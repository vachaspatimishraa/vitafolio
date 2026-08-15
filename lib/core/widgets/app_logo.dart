import 'package:flutter/material.dart';

/// Reusable AppLogo widget with dynamic theme-adapting container (Issue 1 spec).
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? semanticLabel;

  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.semanticLabel = 'Vitafolio Logo',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: width ?? 46,
      height: height ?? 46,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Image.asset(
        'assets/icons/logo.png',
        fit: fit,
        semanticLabel: semanticLabel,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
