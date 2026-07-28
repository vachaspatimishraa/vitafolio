import 'package:flutter/material.dart';
import '../../workflow/models/workflow_state.dart';

class ExperienceBlock extends StatelessWidget {
  final ResumeEntry item;

  const ExperienceBlock({super.key, required this.item});

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
                  item.title, // Company
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${item.startDate} – ${item.isCurrent ? "Present" : item.endDate}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            item.subtitle, // Position
            style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
          ),
          if (item.location.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              item.location,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
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
