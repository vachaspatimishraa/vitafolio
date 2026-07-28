import 'package:flutter/material.dart';

class SkillsBlock extends StatelessWidget {
  final List<String> skills;

  const SkillsBlock({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 6.0,
      runSpacing: 4.0,
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: theme.colorScheme.primaryContainer,
              width: 1,
            ),
          ),
          child: Text(
            skill,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        );
      }).toList(),
    );
  }
}
