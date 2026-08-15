import 'package:flutter/material.dart';
import 'package:vitafolio/data/models/embedded/experience_model.dart';

class ExperienceBlock extends StatelessWidget {
  final ExperienceModel item;

  const ExperienceBlock({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final startDateStr = item.startDate != null
        ? item.startDate!.toIso8601String().split('T').first
        : '';
    final endDateStr = item.isCurrentlyWorking == true
        ? 'Present'
        : (item.endDate != null
              ? item.endDate!.toIso8601String().split('T').first
              : '');

    final dateRange = startDateStr.isNotEmpty || endDateStr.isNotEmpty
        ? '$startDateStr – $endDateStr'
        : '';

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
                  item.company ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (dateRange.isNotEmpty)
                Text(dateRange, style: theme.textTheme.bodySmall),
            ],
          ),
          if (item.position?.isNotEmpty == true)
            Text(
              item.position!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          if (item.location?.isNotEmpty == true) ...[
            const SizedBox(height: 2),
            Text(
              item.location!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (item.description?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(item.description!, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
