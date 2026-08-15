import 'package:flutter/material.dart';

/// Reusable filter chip to toggle selection states adhering to Issue 3 specs.
class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedColor: colorScheme.primaryContainer,
      side: BorderSide(
        color: selected ? colorScheme.primary : theme.dividerColor,
        width: selected ? 1.5 : 1.0,
      ),
      labelStyle: TextStyle(
        color: selected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
      iconTheme: IconThemeData(
        color: selected
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant,
      ),
    );
  }
}
