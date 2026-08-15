import 'package:flutter/material.dart';

/// Reusable Add Language Extended Floating Action Button component.
class AddLanguageButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddLanguageButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      icon: const Icon(Icons.add),
      label: const Text(
        'Add Language',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
