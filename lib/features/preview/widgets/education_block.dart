import 'package:flutter/material.dart';
import 'package:vitafolio/data/models/embedded/education_model.dart';

class EducationBlock extends StatelessWidget {
  final EducationModel item;

  const EducationBlock({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final startDateStr = item.startDate != null
        ? item.startDate!.toIso8601String().split('T').first
        : '';
    final endDateStr = item.isCurrentlyStudying == true
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
                  item.school ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (dateRange.isNotEmpty)
                Text(dateRange, style: theme.textTheme.bodySmall),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.degree ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              if (item.grade?.isNotEmpty == true)
                Text(item.grade!, style: theme.textTheme.bodySmall),
            ],
          ),
          if (item.fieldOfStudy?.isNotEmpty == true) ...[
            const SizedBox(height: 2),
            Text(
              item.fieldOfStudy!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
