import 'package:flutter/material.dart';
import '../../../app/constants/app_spacing.dart';

/// Reusable styled divider for separating sections or layouts.
class SectionDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color? color;

  const SectionDivider({
    super.key,
    this.height = AppSpacing.xl,
    this.thickness = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color:
          color ??
          Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }
}
