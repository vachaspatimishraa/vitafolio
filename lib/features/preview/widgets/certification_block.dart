import 'package:flutter/material.dart';
import 'package:vitafolio/data/models/embedded/certification_model.dart';

class CertificationBlock extends StatelessWidget {
  final CertificationModel item;

  const CertificationBlock({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final dateStr = item.issueDate != null
        ? item.issueDate!.toIso8601String().split('T').first
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
                  item.certificateName ?? '',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (dateStr.isNotEmpty)
                Text(dateStr, style: theme.textTheme.bodySmall),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.organization ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              if (item.credentialUrl?.isNotEmpty == true)
                Text(
                  'Verify',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
