import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Reusable Skill Chip widget displaying a skill label with an optional remove callback and selected state.
class SkillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const SkillChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputChip(
      label: Text(label),
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      selected: isSelected,
      selectedColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceContainerHigh,
      checkmarkColor: colorScheme.onPrimary,
      onPressed: onTap,
      onDeleted: onRemove,
      deleteIcon: onRemove != null
          ? Icon(
              Icons.close_rounded,
              size: 16,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            )
          : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
