import 'package:flutter/material.dart';

/// Reusable Section Add Button aligned right, with compact sizing and primary theme styling.
class SectionAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SectionAddButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: Alignment.centerRight,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        icon: const Icon(Icons.add, size: 18),
        label: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
