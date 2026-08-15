import 'package:flutter/material.dart';

/// Card providing helpful guidelines for writing professional summaries.
class WritingTipsCard extends StatelessWidget {
  const WritingTipsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Writing Tips',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTipRow(context, 'Mention years of relevant experience'),
          _buildTipRow(context, 'Highlight your biggest achievements'),
          _buildTipRow(context, 'Mention your strongest technical skills'),
          _buildTipRow(context, 'Keep it concise and punchy (3-4 sentences)'),
        ],
      ),
    );
  }

  Widget _buildTipRow(BuildContext context, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
