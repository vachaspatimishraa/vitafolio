import 'package:flutter/material.dart';
import '../../workflow/models/workflow_state.dart';

class ProjectsBlock extends StatelessWidget {
  final ResumeEntry item;

  const ProjectsBlock({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title, // Project Name
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (item.extra.isNotEmpty)
                Text(
                  item.extra, // Live Link / Extra
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                ),
            ],
          ),
          if (item.subtitle.isNotEmpty)
            Text(
              item.subtitle, // Technologies
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.secondary,
              ),
            ),
          if (item.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              item.description,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
