import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/data/models/embedded/professional_summary.dart';
import 'package:vitafolio/data/models/embedded/skill_model.dart';
import 'package:vitafolio/data/models/embedded/template_selection.dart';
import 'package:vitafolio/data/models/resume_model.dart';
import 'package:vitafolio/data/repositories/repository_provider.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';

class PreviewAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const PreviewAppBar({super.key});

  Future<void> _saveResume(BuildContext context, WidgetRef ref) async {
    final previewState = ref.read(previewViewModelProvider);
    final workflowState = ref.read(workflowViewModelProvider);
    final repository = ref.read(resumeRepositoryProvider);

    final int? targetId = workflowState.resumeId ?? previewState.resume?.id;
    ResumeModel? resume;
    if (targetId != null) {
      resume = await repository.getResume(targetId);
    }

    final selectedId =
        previewState.selectedTemplate?.id ??
        workflowState.selectedTemplateId ??
        'ats_professional';

    final nameToUse = workflowState.resumeName.isNotEmpty
        ? workflowState.resumeName
        : ((resume?.resumeName?.isNotEmpty ?? false)
            ? resume!.resumeName!
            : 'My Resume');

    if (resume != null) {
      resume.resumeName = nameToUse;
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
        resumeName: nameToUse,
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
        createdDate: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      final created = await repository.createResume(newResume);
      ref.read(workflowViewModelProvider.notifier).setResumeId(created.id);
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
