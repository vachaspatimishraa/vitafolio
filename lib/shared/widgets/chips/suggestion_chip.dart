import 'package:flutter/material.dart';

/// Reusable chip for showing quick actionable suggestions like recommended skills.
class SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const SuggestionChip({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(label), onPressed: onTap);
  }
}
