import 'package:flutter/material.dart';
import '../../workflow/models/workflow_state.dart';

class EducationBlock extends StatelessWidget {
  final ResumeEntry item;

  const EducationBlock({super.key, required this.item});

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
                  item.title, // School
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (item.startDate.isNotEmpty || item.endDate.isNotEmpty)
                Text(
                  '${item.startDate} – ${item.endDate}',
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.subtitle, // Degree
                  style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              if (item.extra.isNotEmpty)
                Text(
                  item.extra, // Grade/CGPA
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          if (item.location.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              item.location,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}
