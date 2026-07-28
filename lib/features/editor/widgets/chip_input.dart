import 'package:flutter/material.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../shared/widgets/chips/skill_chip.dart';

class ChipInput extends StatefulWidget {
  final List<String> chips;
  final List<String> suggestions;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const ChipInput({
    super.key,
    required this.chips,
    required this.suggestions,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<ChipInput> createState() => _ChipInputState();
}

class _ChipInputState extends State<ChipInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return;
    }

    widget.onAdd(normalized);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final filteredSuggestions = widget.suggestions
        .where((skill) => skill.toLowerCase().contains(query))
        .where((skill) => !widget.chips.contains(skill))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: widget.chips
              .map(
                (chip) => SkillChip(
                  label: chip,
                  onDeleted: () => widget.onRemove(chip),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _controller,
          onChanged: (_) => setState(() {}),
          onSubmitted: _submit,
          decoration: InputDecoration(
            labelText: 'Add skill',
            hintText: widget.suggestions.take(3).join(', '),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _submit(_controller.text),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        if (filteredSuggestions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: filteredSuggestions
                .map(
                  (skill) => ActionChip(
                    label: Text(skill),
                    onPressed: () => widget.onAdd(skill),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
