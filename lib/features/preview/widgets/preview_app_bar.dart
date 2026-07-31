import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/constants/app_strings.dart';
import '../../../../data/models/embedded/professional_summary.dart';
import '../../../../data/models/embedded/skill_model.dart';
import '../../../../data/models/embedded/template_selection.dart';
import '../../../../data/models/resume_model.dart';
import '../../../../data/repositories/repository_provider.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../view_model/preview_view_model.dart';

class PreviewAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PreviewAppBar({super.key});

  Future<void> _saveResume(BuildContext context, WidgetRef ref) async {
    final previewState = ref.read(previewViewModelProvider);
    final workflowState = ref.read(workflowViewModelProvider);
    final repository = ref.read(resumeRepositoryProvider);

    ResumeModel? resume = previewState.resume;

    if (resume == null) {
      try {
        final all = await repository.getAllResumes();
        if (all.isNotEmpty) {
          resume = all.first;
        }
      } catch (_) {}
    }

    final selectedId =
        previewState.selectedTemplate?.id ??
        workflowState.selectedTemplateId ??
        'ats_professional';

    if (resume != null) {
      resume.personalInfo = workflowState.personalInfo;
      resume.professionalSummary = ProfessionalSummary()
        ..summary = workflowState.summary;
      resume.education = workflowState.education;
      resume.experience = workflowState.experience;
      resume.skills = workflowState.skills
          .map((s) => SkillModel()..name = s)
          .toList();
      resume.projects = workflowState.projects;
      resume.certifications = workflowState.certifications;
      resume.languages = workflowState.languages;
      resume.selectedTemplate = TemplateSelection()..templateId = selectedId;
      resume.lastUpdated = DateTime.now();

      await repository.updateResume(resume);
      ref.read(previewViewModelProvider.notifier).loadActiveResume(resume.id);
    } else {
      final newResume = ResumeModel(
        resumeName: 'My Resume',
        personalInfo: workflowState.personalInfo,
        professionalSummary: ProfessionalSummary()
          ..summary = workflowState.summary,
        education: workflowState.education,
        experience: workflowState.experience,
        skills: workflowState.skills
            .map((s) => SkillModel()..name = s)
            .toList(),
        projects: workflowState.projects,
        certifications: workflowState.certifications,
        languages: workflowState.languages,
        selectedTemplate: TemplateSelection()..templateId = selectedId,
        lastUpdated: DateTime.now(),
      );
      final created = await repository.createResume(newResume);
      ref.read(previewViewModelProvider.notifier).loadActiveResume(created.id);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resume saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text(AppStrings.preview),
      actions: [
        IconButton(
          icon: const Icon(Icons.save_outlined),
          tooltip: 'Save Resume',
          onPressed: () => _saveResume(context, ref),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
