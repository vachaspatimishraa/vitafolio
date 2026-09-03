import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/profile_image/presentation/viewmodels/profile_image_viewmodel.dart';
import 'package:vitafolio/shared/widgets/helpers/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/wizard_bottom_action_bar.dart';

/// Profile Image Step Page (Step 3 of 11) in Resume Builder.
class ProfileImagePage extends ConsumerWidget {
  const ProfileImagePage({super.key});

  void _handlePrevious(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.personal);
    }
  }

  Future<void> _handleContinue(BuildContext context, WidgetRef ref) async {
    await ref.read(profileImageViewModelProvider.notifier).save();
    if (context.mounted) {
      context.push(AppRoutes.summary);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(profileImageViewModelProvider);
    final notifier = ref.read(profileImageViewModelProvider.notifier);

    final hasImage = state.imagePath != null && state.imagePath!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handlePrevious(context),
        ),
        title: const Text('Profile Image'),
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
        primaryLabel: 'Continue',
        onPrimaryPressed: () => _handleContinue(context, ref),
        isLoading: state.isLoading,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step 3 of 11 Stepper
            const ResumeProgressStepper(currentStepIndex: 2),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Profile Image',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Add a professional photo to your resume.\nThis is optional for all templates.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Avatar Preview Circle
                    Center(
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surfaceContainerHighest,
                          border: Border.all(
                            color: hasImage ? colorScheme.primary : colorScheme.outlineVariant,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: hasImage
                              ? Image.file(
                                  File(state.imagePath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.person_outline,
                                    size: 80,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : Icon(
                                  Icons.person_outline,
                                  size: 80,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Buttons
                    if (!hasImage)
                      ElevatedButton.icon(
                        key: const Key('upload_photo_button'),
                        onPressed: notifier.pickImage,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload Photo'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          ElevatedButton.icon(
                            key: const Key('change_photo_button'),
                            onPressed: notifier.pickImage,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Change Photo'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          TextButton.icon(
                            key: const Key('remove_photo_button'),
                            onPressed: notifier.removeImage,
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            label: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),

                    const SizedBox(height: AppSpacing.lg),
                    if (state.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          state.errorMessage!,
                          style: TextStyle(color: colorScheme.onErrorContainer),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
