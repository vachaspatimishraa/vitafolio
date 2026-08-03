import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart' as core;
import 'package:vitafolio/data/models/embedded/education_model.dart';
import 'package:vitafolio/data/models/embedded/experience_model.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/features/templates/widgets/template_badge.dart';
import 'package:vitafolio/features/templates/widgets/use_template_button.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

final _sampleWorkflowState = WorkflowState(
  personalInfo: PersonalInformation(
    fullName: 'John Doe',
    jobTitle: 'Software Engineer',
    email: 'john@example.com',
    phone: '+1 234 567 890',
  ),
  summary:
      'Experienced software engineer specializing in cross-platform mobile architecture, scalable apps, and UI/UX design.',
  experience: [
    ExperienceModel(
      company: 'Tech Solutions',
      position: 'Senior Developer',
      description: 'Built high performance Flutter and backend services.',
    ),
  ],
  education: [
    EducationModel(school: 'State University', degree: 'B.S. Computer Science'),
  ],
  skills: const ['Flutter', 'Dart', 'Python', 'SQL', 'Git'],
  projects: const [],
  certifications: const [],
  languages: const [],
);

class TemplatePreviewScreen extends ConsumerWidget {
  final core.ResumeTemplate template;

  const TemplatePreviewScreen({super.key, required this.template});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final workflowState = ref.watch(workflowViewModelProvider);
    final domainResume = ref.watch(previewViewModelProvider).resume;

    final renderData = WorkflowState(
      personalInfo: (workflowState.personalInfo.fullName?.isNotEmpty ?? false)
          ? workflowState.personalInfo
          : ((domainResume?.personalInfo?.fullName?.isNotEmpty ?? false)
                ? domainResume!.personalInfo!
                : _sampleWorkflowState.personalInfo),
      summary: workflowState.summary.isNotEmpty
          ? workflowState.summary
          : ((domainResume?.professionalSummary?.summary?.isNotEmpty ?? false)
                ? domainResume!.professionalSummary!.summary!
                : _sampleWorkflowState.summary),
      education: workflowState.education.isNotEmpty
          ? workflowState.education
          : ((domainResume?.education?.isNotEmpty ?? false)
                ? domainResume!.education!
                : _sampleWorkflowState.education),
      experience: workflowState.experience.isNotEmpty
          ? workflowState.experience
          : ((domainResume?.experience?.isNotEmpty ?? false)
                ? domainResume!.experience!
                : _sampleWorkflowState.experience),
      skills: workflowState.skills.isNotEmpty
          ? workflowState.skills
          : ((domainResume?.skills?.isNotEmpty ?? false)
                ? domainResume!.skills!.map((s) => s.name ?? '').toList()
                : _sampleWorkflowState.skills),
      projects: workflowState.projects.isNotEmpty
          ? workflowState.projects
          : (domainResume?.projects ?? workflowState.projects),
      certifications: workflowState.certifications.isNotEmpty
          ? workflowState.certifications
          : (domainResume?.certifications ?? workflowState.certifications),
      languages: workflowState.languages.isNotEmpty
          ? workflowState.languages
          : (domainResume?.languages ?? workflowState.languages),
      selectedTemplateId: template.id,
    );

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
                          child: template.renderer.buildPreview(
                            renderData,
                            context,
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
