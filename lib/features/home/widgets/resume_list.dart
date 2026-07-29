import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/router.dart';
import '../../../data/models/resume_model.dart';
import '../../../shared/widgets/cards/resume_card.dart';
import '../../workflow/view_model/workflow_view_model.dart';
import '../../preview/view_model/preview_view_model.dart';
import '../view_model/home_view_model.dart';
import 'resume_card_menu.dart';

class ResumeList extends ConsumerWidget {
  const ResumeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredResumes = ref.watch(
      homeViewModelProvider.select((state) => state.filteredResumes),
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xxxl,
      ),
      itemCount: filteredResumes.length,
      itemBuilder: (context, index) {
        final resume = filteredResumes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ResumeCard(
            title: resume.resumeName ?? 'Untitled Resume',
            professionalTitle: resume.personalInfo?.jobTitle ?? '',
            lastUpdated: resume.lastUpdated != null
                ? resume.lastUpdated!.toIso8601String().split('T').first
                : '',
            templateName: resume.templateName,
            status: resume.status,
            onTap: () => _openResume(context, ref, resume),
            trailing: ResumeCardMenu(resume: resume),
          ),
        );
      },
    );
  }

  void _openResume(BuildContext context, WidgetRef ref, ResumeModel resume) {
    // Load resume into workflow state & preview view model, then navigate to PreviewScreen
    ref.read(workflowViewModelProvider.notifier).loadExistingResume(resume);
    ref.read(previewViewModelProvider.notifier).loadActiveResume(resume.id);
    context.push(AppRoutes.preview);
  }
}

// Extension to get template name from template ID
extension ResumeModelExtension on ResumeModel {
  String get templateName {
    final templateId = selectedTemplate?.templateId ?? 'modern_clean';
    switch (templateId) {
      case 'modern_clean':
        return 'Modern Clean';
      case 'prof_corp':
        return 'Professional Corporate';
      case 'minimal_elegant':
        return 'Minimal Elegant';
      case 'executive':
        return 'Executive';
      case 'creative':
        return 'Creative';
      case 'ats_friendly':
        return 'ATS Friendly';
      default:
        return templateId
            .split('_')
            .map((word) {
              if (word.isEmpty) return word;
              return word[0].toUpperCase() + word.substring(1);
            })
            .join(' ');
    }
  }
}
