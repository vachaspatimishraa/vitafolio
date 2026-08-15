import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/features/skills/presentation/widgets/skill_chip.dart';

/// Reusable Wrap widget automatically arranging a collection of SkillChip items.
class SkillsChipWrap extends StatelessWidget {
  final List<String> skills;
  final ValueChanged<String>? onRemoveSkill;
  final ValueChanged<String>? onSelectSkill;
  final String? selectedSkill;

  const SkillsChipWrap({
    super.key,
    required this.skills,
    this.onRemoveSkill,
    this.onSelectSkill,
    this.selectedSkill,
  });

  @override
  Widget build(BuildContext context) {
    if (skills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: skills.map((skill) {
        final bool isSelected = skill == selectedSkill;
        return SkillChip(
          label: skill,
          isSelected: isSelected,
          onTap: onSelectSkill != null ? () => onSelectSkill!(skill) : null,
          onRemove: onRemoveSkill != null ? () => onRemoveSkill!(skill) : null,
        );
      }).toList(),
    );
  }
}
