import 'package:flutter/material.dart';
import '../../../../data/models/embedded/project_model.dart';

class ProjectsBlock extends StatelessWidget {
  final ProjectModel item;

  const ProjectsBlock({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final links = [
      if (item.githubUrl?.isNotEmpty == true) 'GitHub',
      if (item.liveDemoUrl?.isNotEmpty == true) 'Live Demo',
    ].join(' | ');

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
                  item.projectName ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (links.isNotEmpty)
                Text(
                  links,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
          if (item.technologies?.isNotEmpty == true)
            Text(
              item.technologies!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.secondary,
              ),
            ),
          if (item.description?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(item.description!, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
