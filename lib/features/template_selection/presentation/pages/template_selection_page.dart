import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart';
import 'package:vitafolio/features/template_selection/presentation/viewmodels/template_selection_viewmodel.dart';
import 'package:vitafolio/features/template_selection/presentation/widgets/selected_template_card.dart';
import 'package:vitafolio/features/template_selection/presentation/widgets/template_grid.dart';
import 'package:vitafolio/features/template_selection/presentation/widgets/template_preview_dialog.dart';
import 'package:vitafolio/shared/widgets/helpers/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/wizard_bottom_action_bar.dart';

/// Screen for choosing a resume template matching 10-step wizard design.
class TemplateSelectionPage extends ConsumerWidget {
  const TemplateSelectionPage({super.key});

  void _handleSelectTemplate(WidgetRef ref, ResumeTemplate template) {
    ref
        .read(templateSelectionViewModelProvider.notifier)
        .selectTemplate(template.id);
  }

  void _handleShowPreview(
    BuildContext context,
    WidgetRef ref,
    ResumeTemplate template,
  ) {
    final state = ref.read(templateSelectionViewModelProvider);
    showDialog(
      context: context,
      builder: (context) => TemplatePreviewDialog(
        template: template,
        isSelected: state.selectedTemplateId == template.id,
        onSelect: () => _handleSelectTemplate(ref, template),
      ),
    );
  }

  Future<void> _handleContinue(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(templateSelectionViewModelProvider.notifier)
        .saveSelection();
    if (!context.mounted) return;
    if (success) {
      context.push(AppRoutes.personal);
    } else {
      final errorMsg =
          ref.read(templateSelectionViewModelProvider).errorMessage ??
          'Failed to save template selection';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _handlePrevious(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(templateSelectionViewModelProvider);

    ResumeTemplate? selectedTemplate;
    if (state.selectedTemplateId.isNotEmpty) {
      final matches =
          state.templates.where((t) => t.id == state.selectedTemplateId);
      if (matches.isNotEmpty) {
        selectedTemplate = matches.first;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handlePrevious(context),
        ),
        title: const Text(
          'Choose Template',
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
      body: SafeArea(
        child: Column(
          children: [
            // Shared 10-Step Progress Stepper (Step 1 of 10)
            const ResumeProgressStepper(currentStepIndex: 0),

            // Page Header & Grid Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title & Subtitle
                    Text(
                      'Choose Your Resume Template',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Select a professional template. You can change it later without losing your information.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Template Grid / Empty Controlled State
                    if (state.templates.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: colorScheme.outlineVariant),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.style_outlined,
                              size: 48,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'No Templates Configured',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'The template system is currently being reset.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      TemplateGrid(
                        templates: state.templates,
                        selectedTemplateId: state.selectedTemplateId,
                        onSelect: (template) =>
                            _handleSelectTemplate(ref, template),
                        onPreview: (template) =>
                            _handleShowPreview(context, ref, template),
                      ),

                    // Selected Template Card (Visible when selected)
                    if (selectedTemplate != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      SelectedTemplateCard(template: selectedTemplate),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: WizardBottomActionBar(
        primaryLabel: 'Continue',
        onPrimaryPressed: !state.isLoading
            ? () => _handleContinue(context, ref)
            : null,
        secondaryLabel: 'Previous',
        onSecondaryPressed: !state.isLoading
            ? () => _handlePrevious(context)
            : null,
        isLoading: state.isLoading,
      ),
    );
  }
}
