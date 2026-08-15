import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDateRange() {
    final format = DateFormat('MMM yyyy');
    final startStr =
        project.startDate != null ? format.format(project.startDate!) : '';
    final endStr = project.isOngoing
        ? 'Present'
        : (project.endDate != null ? format.format(project.endDate!) : '');

    if (startStr.isEmpty && endStr.isEmpty) return '';
    if (startStr.isEmpty) return endStr;
    if (endStr.isEmpty) return startStr;
    return '$startStr - $endStr';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateRange = _formatDateRange();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Project Name, Role & Popup Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (project.role.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          project.role,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 12),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              size: 20, color: colorScheme.error),
                          const SizedBox(width: 12),
                          Text(
                            'Delete',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Date Range & Ongoing Badge
            if (dateRange.isNotEmpty || project.isOngoing) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (dateRange.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          dateRange,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  if (project.isOngoing)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: Colors.green,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Ongoing',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],

            // Project URL
            if (project.projectUrl.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.link,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      project.projectUrl,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // Description
            if (project.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                project.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],

            // Technologies Chips
            if (project.technologies.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: project.technologies.map((tech) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      tech,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
