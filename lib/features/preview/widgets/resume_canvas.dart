import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/core/templates/repository/template_repository.dart'
    as core_repo;
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';
import 'package:vitafolio/features/preview/widgets/preview_loading_view.dart';

class ResumeCanvas extends ConsumerWidget {
  const ResumeCanvas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(previewViewModelProvider);
    final workflowState = ref.watch(workflowViewModelProvider);

    if (previewState.isLoading) {
      return const PreviewLoadingView();
    }

    if (previewState.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                previewState.errorMessage ?? 'Failed to load preview',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ref
                      .read(previewViewModelProvider.notifier)
                      .loadActiveResume();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final selectedTemplateId =
        previewState.selectedTemplate?.id ??
        workflowState.selectedTemplateId ??
        'ats_professional';

    final template = core_repo.TemplateRepository().getTemplate(
      selectedTemplateId,
    );

    // Merge workflow state or create state from loaded domain resume model
    final domainResume = previewState.resume;
    final renderData = WorkflowState(
      personalInfo: workflowState.personalInfo.fullName?.isNotEmpty ?? false
          ? workflowState.personalInfo
          : (domainResume?.personalInfo ?? workflowState.personalInfo),
      summary: workflowState.summary.isNotEmpty
          ? workflowState.summary
          : (domainResume?.professionalSummary?.summary ??
                workflowState.summary),
      education: workflowState.education.isNotEmpty
          ? workflowState.education
          : (domainResume?.education ?? workflowState.education),
      experience: workflowState.experience.isNotEmpty
          ? workflowState.experience
          : (domainResume?.experience ?? workflowState.experience),
      skills: workflowState.skills.isNotEmpty
          ? workflowState.skills
          : (domainResume?.skills?.map((s) => s.name ?? '').toList() ??
                workflowState.skills),
      projects: workflowState.projects.isNotEmpty
          ? workflowState.projects
          : (domainResume?.projects ?? workflowState.projects),
      certifications: workflowState.certifications.isNotEmpty
          ? workflowState.certifications
          : (domainResume?.certifications ?? workflowState.certifications),
      languages: workflowState.languages.isNotEmpty
          ? workflowState.languages
          : (domainResume?.languages ?? workflowState.languages),
      selectedTemplateId: selectedTemplateId,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 3.0,
          scaleEnabled: true,
          panEnabled: true,
          child: Center(
            child: Transform.scale(
              scale: previewState.scale,
              child: AspectRatio(
                aspectRatio: 1 / 1.414, // Standard A4 Aspect Ratio
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  // Enforce Paper Appearance (Light theme context, white bg, dark text)
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      scaffoldBackgroundColor: Colors.white,
                      colorScheme: const ColorScheme.light(
                        surface: Colors.white,
                        onSurface: Colors.black,
                      ),
                    ),
                    child: Builder(
                      builder: (canvasContext) {
                        return template.renderer.buildPreview(
                          renderData,
                          canvasContext,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
