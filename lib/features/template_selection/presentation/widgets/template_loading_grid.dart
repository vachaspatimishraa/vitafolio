import 'package:flutter/material.dart';

/// Shimmer loading grid placeholder widget for template loading state.
class TemplateLoadingGrid extends StatelessWidget {
  const TemplateLoadingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 100,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: 140,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
