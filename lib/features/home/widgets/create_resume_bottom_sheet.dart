import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/presentation/providers/resume_domain_providers.dart';
import 'package:vitafolio/features/editor/view_model/editor_view_model.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';

/// Refined Create Resume Bottom Sheet matching Stitch Vitafolio design spec.
class CreateResumeBottomSheet extends ConsumerWidget {
  const CreateResumeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            const SizedBox(height: AppSpacing.md),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // Title
            Text(
              'How would you like to create it?',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Option 1: Start from scratch
            _buildOptionCard(
              context: context,
              icon: Icons.edit_note,
              title: 'Start from scratch',
              description: "We'll help you build it step-by-step.",
              onTap: () async {
                Navigator.pop(context);
                ref.read(editorViewModelProvider.notifier).resetState();
                ref.read(workflowViewModelProvider.notifier).createNewResume();
                
                final newResume = Resume(
                  id: const ResumeId(''),
                  title: 'Untitled Resume',
                  selectedTemplateId: const TemplateId('modern_clean'),
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                final createdResume = await ref
                    .read(createResumeUseCaseProvider)
                    .call(newResume);

                ref.read(activeResumeIdProvider.notifier).state = createdResume.id;

                if (context.mounted) {
                  context.push(AppRoutes.templates);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            // Option 2: Upload existing resume
            _buildOptionCard(
              context: context,
              icon: Icons.upload_file,
              title: 'Upload an existing resume',
              description: "We'll format and fill it out for you.",
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.upload);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                // Rounded square icon container matching screenshot design
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
