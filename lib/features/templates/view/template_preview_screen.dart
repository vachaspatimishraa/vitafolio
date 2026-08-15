import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart' as core;
import 'package:vitafolio/features/templates/widgets/template_badge.dart';
import 'package:vitafolio/features/templates/widgets/use_template_button.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';



class TemplatePreviewScreen extends ConsumerWidget {
  final core.ResumeTemplate template;

  const TemplatePreviewScreen({super.key, required this.template});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(template.name),
        actions: [
          if (template.category == core.TemplateCategory.ats)
            const Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: TemplateBadge(),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Hero(
                    tag: 'template_${template.id}',
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 520,
                        minHeight: 400,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 3.0,
                          child: Image.asset(
                            template.previewAsset,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Text('Template Preview Unavailable'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.name,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            template.category.label,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (template.category ==
                              core.TemplateCategory.ats) ...[
                            Row(
                              children: [
                                const TemplateBadge(),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'Optimized for applicant tracking systems',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          Text(
                            template.description,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: UseTemplateButton(templateId: template.id),
            ),
          ),
        ],
      ),
    );
  }
}
