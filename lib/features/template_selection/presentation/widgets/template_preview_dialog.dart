import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart';

/// Fullscreen A4 template preview dialog using real template renderer.
class TemplatePreviewDialog extends StatelessWidget {
  final ResumeTemplate template;
  final bool isSelected;
  final VoidCallback onSelect;

  const TemplatePreviewDialog({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 500,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          color: colorScheme.surface,
          child: Column(
            children: [
              // Dialog Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            template.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Real Template Preview A4 Canvas Container
              Expanded(
                child: Container(
                  color: colorScheme.surfaceContainerHigh,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1 / 1.414, // Standard A4 Aspect Ratio
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          template.previewAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image_outlined, size: 48, color: Colors.amber),
                                SizedBox(height: 8),
                                Text('Preview Image Unavailable'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Action Footer
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onSelect();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(isSelected ? Icons.check : Icons.touch_app),
                    label: Text(
                      isSelected ? 'Selected' : 'Use This Template',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
