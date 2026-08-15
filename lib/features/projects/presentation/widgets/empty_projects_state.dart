import 'package:flutter/material.dart';
import 'package:vitafolio/shared/widgets/section_add_button.dart';

class EmptyProjectsState extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyProjectsState({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_special_outlined,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Projects Added Yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Showcase personal, academic, or professional projects to highlight your key achievements and tech stack.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            SectionAddButton(
              label: 'Add Project',
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}
