import 'package:flutter/material.dart';
import 'package:vitafolio/shared/widgets/app_hybrid_search_field.dart';

/// Searchable input field supporting typing, auto-suggest dropdown, Enter key, and custom skill creation.
class SkillsInputField extends StatelessWidget {
  final ValueChanged<String> onAddSkill;
  final List<String> mockSuggestions;

  const SkillsInputField({
    super.key,
    required this.onAddSkill,
    this.mockSuggestions = const [
      'Flutter',
      'Dart',
      'Firebase',
      'Java',
      'Kotlin',
      'REST API',
      'GraphQL',
      'Git',
      'SQL',
      'Docker',
      'Python',
      'TypeScript',
      'React',
      'Node.js',
      'AWS',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return AppHybridSearchField(
      label: 'Add Skill',
      hintText: 'Search or type skill (e.g. Flutter, Go)...',
      prefixIcon: Icons.psychology_outlined,
      suggestions: mockSuggestions,
      onSelected: onAddSkill,
    );
  }
}
