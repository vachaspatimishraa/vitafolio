import 'package:flutter/material.dart';

/// Reusable Skill Level Selector Material 3 dropdown component.
class SkillLevelSelector extends StatelessWidget {
  final String? selectedLevel;
  final ValueChanged<String?> onChanged;

  static const List<String> kSkillLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  const SkillLevelSelector({
    super.key,
    required this.selectedLevel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedLevel,
      decoration: InputDecoration(
        labelText: 'Proficiency Level',
        prefixIcon: const Icon(Icons.bar_chart_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: kSkillLevels.map((level) {
        return DropdownMenuItem(
          value: level,
          child: Text(level),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
