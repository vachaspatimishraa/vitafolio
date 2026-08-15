import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/features/skills/presentation/widgets/skill_chip.dart';

/// Suggested Skills Section displaying popular skill chips with tap-to-add callbacks.
class SuggestedSkillsSection extends StatelessWidget {
  final ValueChanged<String> onSelectSuggestedSkill;
  final List<String> popularSkills;

  const SuggestedSkillsSection({
    super.key,
    required this.onSelectSuggestedSkill,
    this.popularSkills = const [
      'Flutter',
      'Android',
      'Kotlin',
      'Git',
      'Firebase',
      'SQL',
      'REST API',
      'Dart',
    ],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.stars_outlined,
              size: 18,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Popular Suggested Skills',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: popularSkills.map((skill) {
            return SkillChip(
              label: '+ $skill',
              onTap: () => onSelectSuggestedSkill(skill),
            );
          }).toList(),
        ),
      ],
    );
  }
}
