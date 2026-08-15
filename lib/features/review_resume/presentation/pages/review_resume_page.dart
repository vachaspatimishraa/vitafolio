import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/review_resume/presentation/viewmodels/review_resume_viewmodel.dart';
import 'package:vitafolio/features/review_resume/presentation/widgets/completion_progress_card.dart';
import 'package:vitafolio/features/review_resume/presentation/widgets/missing_section_card.dart';
import 'package:vitafolio/features/review_resume/presentation/widgets/resume_preview_card.dart';
import 'package:vitafolio/features/review_resume/presentation/widgets/resume_section_tile.dart';
import 'package:vitafolio/shared/widgets/helpers/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/wizard_bottom_action_bar.dart';

/// Review & Generate Resume Screen Page (Step 10 of 10).
class ReviewResumePage extends ConsumerWidget {
  const ReviewResumePage({super.key});

  void _handlePrevious(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.languages);
    }
  }

  Future<void> _handleGenerateResume(BuildContext context, WidgetRef ref) async {
    final state = ref.read(reviewResumeViewModelProvider);
    final resumeTitle = state.resume?.title ?? 'Resume';
    final bytes = await ref.read(reviewResumeViewModelProvider.notifier).generateResume();
    if (!context.mounted) return;
    
    if (bytes != null && bytes.isNotEmpty) {
      try {
        final tempDir = await getTemporaryDirectory();
        final safeTitle = resumeTitle.replaceAll(RegExp(r'\s+'), '_');
        final file = File('${tempDir.path}/$safeTitle.pdf');
        await file.writeAsBytes(bytes, flush: true);

        await Share.shareXFiles([XFile(file.path)], text: resumeTitle);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Generated PDF saved (${bytes.length} bytes), share error: $e')),
          );
        }
      }
    }
  }

  void _handlePreview(BuildContext context) {
    context.push(AppRoutes.preview);
  }

  void _handleEditSection(BuildContext context, WidgetRef ref, String sectionTitle, String route) {
    ref.read(reviewResumeViewModelProvider.notifier).selectSection(sectionTitle);
    context.push(route);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(reviewResumeViewModelProvider);

    ref.listen(reviewResumeViewModelProvider.select((s) => s.errorMessage), (prev, next) {
      if (next != null && next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: colorScheme.error),
        );
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handlePrevious(context),
        ),
        title: const Text(
          'Review & Generate',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      bottomNavigationBar: WizardBottomActionBar(
        secondaryLabel: 'Previous',
        onSecondaryPressed: () => _handlePrevious(context),
        primaryLabel: 'Generate Resume',
        onPrimaryPressed: state.resume == null
            ? null
            : () => _handleGenerateResume(context, ref),
        isLoading: state.isGenerating,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Stepper (Step 11 of 11)
            const ResumeProgressStepper(currentStepIndex: 10),

            // Main Viewport Content Area
            Expanded(
              child: _buildBodyContent(context, ref, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, WidgetRef ref, ReviewResumeState state) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text('Loading resume details...'),
          ],
        ),
      );
    }

    if (state.errorMessage != null && state.errorMessage!.isNotEmpty && state.resume == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: () => ref.read(reviewResumeViewModelProvider.notifier).loadResume(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.resume == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description_outlined, size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No Active Resume Selected',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Please select or create a resume to review.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.templates),
                child: const Text('Create / Select Resume'),
              ),
            ],
          ),
        ),
      );
    }

    final resume = state.resume!;
    final missingMandatorySections = state.sections
        .where((s) => !s.isCompleted && s.title == 'Personal Details')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Text(
            'Review Your Resume',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Review your details, edit any section, and generate your high-resolution ATS-optimized resume.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Resume Preview Card
          ResumePreviewCard(
            templateName: state.templateName,
            previewImage: state.previewImage,
            atsFriendly: state.isAtsFriendly,
            onPreview: () => _handlePreview(context),
          ),
          const SizedBox(height: AppSpacing.md),

          // Live Active Resume Data Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 20, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        resume.personalDetails?.fullName.isNotEmpty == true
                            ? resume.personalDetails!.fullName
                            : resume.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (resume.personalDetails?.email.isNotEmpty == true ||
                    resume.personalDetails?.phoneNumber.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    [
                      if (resume.personalDetails?.email.isNotEmpty == true)
                        resume.personalDetails!.email,
                      if (resume.personalDetails?.phoneNumber.isNotEmpty == true)
                        resume.personalDetails!.phoneNumber,
                    ].join(' • '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (resume.summary?.summaryText.isNotEmpty == true) ...[
                  const Divider(height: 16),
                  Text(
                    resume.summary!.summaryText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const Divider(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _buildSummaryChip(context, 'Exp: ${resume.experiences.length}'),
                    _buildSummaryChip(context, 'Projects: ${resume.projects.length}'),
                    _buildSummaryChip(context, 'Edu: ${resume.educations.length}'),
                    _buildSummaryChip(context, 'Skills: ${resume.skills.length}'),
                    _buildSummaryChip(context, 'Certs: ${resume.certifications.length}'),
                    _buildSummaryChip(context, 'Langs: ${resume.languages.length}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Completion Progress Card
          CompletionProgressCard(
            completedSections: state.completedSections,
            totalSections: state.totalSections,
            percentage: state.completionPercentage,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Missing Mandatory Sections Warnings (Action Required ONLY for Personal Details)
          if (missingMandatorySections.isNotEmpty) ...[
            Text(
              'Action Required',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            ...missingMandatorySections.map(
              (missing) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: MissingSectionCard(
                  title: 'Missing ${missing.title}',
                  description: 'Add your ${missing.title.toLowerCase()} to complete your profile.',
                  onTap: () => _handleEditSection(
                      context, ref, missing.title, missing.route),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Section Tiles
          Text(
            'Resume Sections',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ...state.sections.map(
            (section) => ResumeSectionTile(
              title: section.title,
              completed: section.isCompleted,
              onEdit: () => _handleEditSection(
                  context, ref, section.title, section.route),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
