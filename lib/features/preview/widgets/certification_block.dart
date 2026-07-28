import 'package:flutter/material.dart';
import '../../workflow/models/workflow_state.dart';

class CertificationBlock extends StatelessWidget {
  final ResumeEntry item;

  const CertificationBlock({super.key, required this.item});

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
                  item.title, // Certification Name
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              if (item.startDate.isNotEmpty)
                Text(
                  item.startDate, // Date
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.subtitle, // Issuer / Organization
                  style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
              if (item.url.isNotEmpty)
                Text(
                  'Verify',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
