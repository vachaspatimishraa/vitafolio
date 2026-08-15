import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart';

/// Card widget representing an individual resume template item from the real TemplateRepository.
class TemplateCard extends StatelessWidget {
  final ResumeTemplate template;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onPreviewTap;

  const TemplateCard({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
    required this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? primaryColor : colorScheme.outlineVariant,
          width: isSelected ? 2.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? primaryColor.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visual Template Representation Header
              Expanded(
                child: Stack(
                  children: [
                    InkWell(
                      onTap: onPreviewTap,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: template.accentColor.withValues(alpha: 0.05),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.asset(
                            template.previewAsset,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 36,
                                color: colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Category / ATS Rating Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_outlined,
                              size: 11,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'ATS ${template.atsRating}/5',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSecondaryContainer,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Selection Checkmark Badge
                    if (isSelected)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Template Title & Metadata Section
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      template.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
