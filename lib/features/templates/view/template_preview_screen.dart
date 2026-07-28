import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/template_model.dart';
import '../widgets/template_badge.dart';
import '../widgets/use_template_button.dart';
import '../../../app/constants/app_spacing.dart';

class TemplatePreviewScreen extends ConsumerWidget {
  final TemplateModel template;

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
          if (template.isAtsFriendly)
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
                        maxHeight: 500,
                        minHeight: 300,
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
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 80,
                              color: colorScheme.primary.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              template.name,
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              template.category,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
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
                            template.category,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (template.isAtsFriendly) ...[
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
                            'A premium design template perfect for showcase resumes.',
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
