import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/shared/widgets/cards/resume_card.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';
import 'package:vitafolio/features/home/view_model/home_view_model.dart';
import 'package:vitafolio/features/home/widgets/resume_card_menu.dart';

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
        final jobTitle = resume.personalDetails?.jobTitle;
        final hasJobTitle = jobTitle != null && jobTitle.trim().isNotEmpty;
        final displayTitle = (resume.title.isNotEmpty && resume.title != 'Untitled Resume')
            ? resume.title
            : (hasJobTitle ? jobTitle.trim() : (resume.title.isNotEmpty ? resume.title : 'Untitled Resume'));

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ResumeCard(
            title: displayTitle,
            professionalTitle: jobTitle ?? '',
            lastUpdated: resume.updatedAt.toIso8601String().split('T').first,
            templateName: resume.selectedTemplateId.value,
            onTap: () => _openResume(context, ref, resume),
            trailing: ResumeCardMenu(resume: resume),
          ),
        );
      },
    );
  }

  void _openResume(BuildContext context, WidgetRef ref, Resume resume) {
    ref.read(activeResumeIdProvider.notifier).state = resume.id;
    context.push(AppRoutes.preview);
  }
}

// Extension to get template name from template ID
extension ResumeExtension on Resume {
  String get templateName {
    final templateId = selectedTemplateId.value;
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
