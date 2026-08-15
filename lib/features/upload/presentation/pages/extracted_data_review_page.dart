import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/upload/presentation/viewmodels/upload_resume_viewmodel.dart';
import 'package:vitafolio/shared/widgets/wizard_bottom_action_bar.dart';

class ExtractedDataReviewPage extends ConsumerWidget {
  const ExtractedDataReviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(uploadResumeViewModelProvider);
    final resume = state.extractedResume;

    if (resume == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Extracted Data Review')),
        body: const Center(
          child: Text('No extracted data found. Please select a resume file first.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Review Extracted Data'),
        centerTitle: true,
      ),
      bottomNavigationBar: WizardBottomActionBar(
        secondaryLabel: 'Cancel',
        onSecondaryPressed: () => context.pop(),
        primaryLabel: 'Import & Continue',
        onPrimaryPressed: () async {
          final success = await ref
              .read(uploadResumeViewModelProvider.notifier)
              .confirmImportAndSave();
          if (success && context.mounted) {
            context.go(AppRoutes.templates);
          }
        },
        isLoading: state.isLoading,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resume Imported Successfully!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Review the extracted details below before populating your resume builder.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Personal Details Card
              Builder(
                builder: (context) {
                  final pd = resume.personalDetails;
                  final jobRole = pd?.jobTitle;
                  return _buildSectionCard(
                    context,
                    title: 'Personal Details',
                    icon: Icons.person_outline,
                    content: [
                      if (pd?.fullName != null && pd!.fullName.isNotEmpty)
                        'Name: ${pd.fullName}',
                      if (jobRole != null && jobRole.isNotEmpty)
                        'Job Role: $jobRole',
                      if (pd?.email != null && pd!.email.isNotEmpty)
                        'Email: ${pd.email}',
                      if (pd?.phoneNumber != null && pd!.phoneNumber.isNotEmpty)
                        'Phone: ${pd.phoneNumber}',
                      if (pd?.linkedinUrl != null && pd!.linkedinUrl!.isNotEmpty)
                        'LinkedIn: ${pd.linkedinUrl}',
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Summary Card
              if (resume.summary?.summaryText != null &&
                  resume.summary!.summaryText.isNotEmpty)
                _buildSectionCard(
                  context,
                  title: 'Professional Summary',
                  icon: Icons.article_outlined,
                  content: [resume.summary!.summaryText],
                ),
              const SizedBox(height: AppSpacing.md),

              // Experiences Card
              _buildSectionCard(
                context,
                title: 'Experience (${resume.experiences.length} found)',
                icon: Icons.work_outline,
                content: resume.experiences
                    .map((e) => '${e.jobTitle} at ${e.company}')
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),

              // Education Card
              _buildSectionCard(
                context,
                title: 'Education (${resume.educations.length} found)',
                icon: Icons.school_outlined,
                content: resume.educations
                    .map((e) => '${e.degree} - ${e.institution}')
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),

              // Skills Card
              _buildSectionCard(
                context,
                title: 'Skills (${resume.skills.length} found)',
                icon: Icons.build_outlined,
                content: [resume.skills.map((s) => s.name).join(', ')],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<String> content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (content.isEmpty || content.every((c) => c.isEmpty))
            Text(
              'None detected (will remain empty)',
              style: TextStyle(color: colorScheme.outline),
            )
          else
            ...content.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
