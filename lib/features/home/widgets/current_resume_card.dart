import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/router.dart';
import '../../../core/templates/repository/template_repository.dart';
import '../../../data/models/resume_model.dart';
import '../../editor/view_model/editor_view_model.dart';
import '../../preview/view_model/preview_view_model.dart';
import '../../preview/widgets/export_pdf_button.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../view_model/home_view_model.dart';

class CurrentResumeCard extends ConsumerWidget {
  const CurrentResumeCard({super.key});

  double _calculateCompletion(ResumeModel resume) {
    int filled = 0;
    int total = 7;

    if (resume.personalInfo?.fullName?.isNotEmpty ?? false) filled++;
    if (resume.professionalSummary?.summary?.isNotEmpty ?? false) filled++;
    if (resume.experience?.isNotEmpty ?? false) filled++;
    if (resume.education?.isNotEmpty ?? false) filled++;
    if (resume.skills?.isNotEmpty ?? false) filled++;
    if (resume.projects?.isNotEmpty ?? false) filled++;
    if (resume.certifications?.isNotEmpty ?? false) filled++;

    return filled / total;
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Recently';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumes = ref.watch(homeViewModelProvider.select((s) => s.resumes));

    if (resumes.isEmpty) {
      return const SizedBox.shrink();
    }

    final resume = resumes.first;
    final templateRepository = TemplateRepository();
    final templateId = resume.selectedTemplate?.templateId ?? 'ats_professional';
    final templateName = templateRepository.getTemplate(templateId).name;
    final completion = _calculateCompletion(resume);
    final completionPercentage = (completion * 100).toInt();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'ACTIVE RESUME',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    'Updated ${_formatDate(resume.lastUpdated)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                resume.resumeName ?? 'My Resume',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.style_outlined, size: 16, color: colorScheme.secondary),
                  const SizedBox(width: 4),
                  Text(
                    'Template: $templateName',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Completion',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$completionPercentage%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: completion,
                  minHeight: 8,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.md),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilledButton.icon(
                      onPressed: () {
                        ref.read(editorViewModelProvider.notifier).loadResume(resume);
                        ref.read(workflowViewModelProvider.notifier).loadExistingResume(resume);
                        context.push(AppRoutes.editor);
                      },
                      icon: const Icon(Icons.edit_note, size: 18),
                      label: const Text('Edit Details'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () {
                        ref.read(previewViewModelProvider.notifier).loadActiveResume(resume.id);
                        context.push(AppRoutes.preview);
                      },
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('Preview'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const ExportPdfButton(),
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
