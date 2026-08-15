import 'package:flutter/material.dart';

/// Reusable Add Certification Extended Floating Action Button component.
class AddCertificationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddCertificationButton({
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
        'Add Certification',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
