import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../workflow/models/workflow_state.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../renderers/renderer_factory.dart';
import '../view_model/preview_view_model.dart';
import 'preview_loading_view.dart';

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
                  ref.read(previewViewModelProvider.notifier).loadActiveResume();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final selectedTemplateId = previewState.selectedTemplate?.id ??
        workflowState.selectedTemplateId ??
        'modern_clean';
        
    final renderer = RendererFactory().getRenderer(selectedTemplateId);

    // Merge workflow state or create state from loaded domain resume model
    final domainResume = previewState.resume;
    final renderData = WorkflowState(
      personalInfo: workflowState.personalInfo.fullName.isNotEmpty
          ? workflowState.personalInfo
          : (domainResume?.personalInfo ?? workflowState.personalInfo),
      summary: workflowState.summary.isNotEmpty
          ? workflowState.summary
          : (domainResume?.summary ?? workflowState.summary),
      education: workflowState.education.isNotEmpty
          ? workflowState.education
          : (domainResume?.education ?? workflowState.education),
      experience: workflowState.experience.isNotEmpty
          ? workflowState.experience
          : (domainResume?.experience ?? workflowState.experience),
      skills: workflowState.skills.isNotEmpty
          ? workflowState.skills
          : (domainResume?.skills ?? workflowState.skills),
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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 3.0,
        scaleEnabled: true,
        panEnabled: true,
        child: AspectRatio(
          aspectRatio: 1 / 1.414, // Standard A4 Aspect Ratio
          child: Transform.scale(
            scale: previewState.scale,
            child: Card(
              color: isDark ? Colors.grey[900] : Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: SingleChildScrollView(
                  child: renderer.render(renderData, context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
