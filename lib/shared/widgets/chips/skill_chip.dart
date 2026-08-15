import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Vitafolio v2.0 Skill Chip adhering to Issue 3 color specifications
class SkillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;

  const SkillChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusChip),
          border: Border.all(
            color: isSelected ? colorScheme.primary : theme.dividerColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check_rounded,
                size: 16,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
