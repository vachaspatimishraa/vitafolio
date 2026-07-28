import 'package:flutter/material.dart';

/// A premium reusable Chip displaying a skill, with an optional trailing delete icon.
class SkillChip extends StatelessWidget {
  final String label;
  final VoidCallback? onDeleted;

  const SkillChip({super.key, required this.label, this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIcon: onDeleted != null ? const Icon(Icons.close, size: 16) : null,
    );
  }
}
