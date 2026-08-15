import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/features/upload/presentation/pages/extracted_data_review_page.dart';
import 'package:vitafolio/features/upload/presentation/viewmodels/upload_resume_viewmodel.dart';
import 'package:vitafolio/features/upload/presentation/widgets/info_card.dart';
import 'package:vitafolio/features/upload/presentation/widgets/selected_file_card.dart';
import 'package:vitafolio/features/upload/presentation/widgets/supported_formats.dart';
import 'package:vitafolio/features/upload/presentation/widgets/upload_card.dart';
import 'package:vitafolio/features/upload/presentation/widgets/upload_loading_widget.dart';

/// Screen for uploading an existing resume (PDF/DOCX) matching Stitch design.
class UploadResumePage extends ConsumerWidget {
  const UploadResumePage({super.key});

  void _handlePickFile(WidgetRef ref) {
    ref.read(uploadResumeViewModelProvider.notifier).pickRealFile();
  }

  void _handleRemoveFile(WidgetRef ref) {
    ref.read(uploadResumeViewModelProvider.notifier).clearSelectedFile();
  }

  Future<void> _handleContinue(BuildContext context, WidgetRef ref) async {
    final state = ref.read(uploadResumeViewModelProvider);
    if (state.selectedFileName == null) return;

    final parsed = await ref
        .read(uploadResumeViewModelProvider.notifier)
        .parseSelectedFile();

    if (!context.mounted) return;

    if (parsed != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ExtractedDataReviewPage(),
        ),
      );
    } else {
      final errorMsg = ref.read(uploadResumeViewModelProvider).errorMessage;
      if (errorMsg != null && errorMsg.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(uploadResumeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Upload Resume'),
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
        child: state.isLoading
            ? const UploadLoadingWidget()
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Resume Progress Header
                          Row(
                            children: [
                              Text(
                                'STEP 1 OF 3',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              Text(
                                ' : UPLOAD → EXTRACT → CONTINUE',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // Page Title & Subtitle
                          Text(
                            'Upload Existing Resume',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Upload your existing resume and Vitafolio will automatically extract available information.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Upload Card or Selected File Card
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state.selectedFileName == null
                                ? UploadCard(onBrowse: () => _handlePickFile(ref))
                                : SelectedFileCard(
                                    fileName: state.selectedFileName!,
                                    fileSize: state.selectedFileSize!,
                                    onReplace: () => _handlePickFile(ref),
                                    onRemove: () => _handleRemoveFile(ref),
                                  ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Supported File Types
                          const SupportedFormats(),
                          const SizedBox(height: AppSpacing.lg),

                          // Information Card
                          const InfoCard(),
                        ],
                      ),
                    ),
                  ),

                  // Sticky Bottom Navigation
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: OutlinedButton(
                              onPressed: () => context.pop(),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                side: BorderSide(color: colorScheme.outline),
                              ),
                              child: Text(
                                'Previous',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: state.selectedFileName != null
                                  ? () => _handleContinue(context, ref)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                disabledBackgroundColor: colorScheme.primary
                                    .withValues(alpha: 0.38),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: state.selectedFileName != null
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface
                                              .withValues(alpha: 0.38),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                    color: state.selectedFileName != null
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface
                                            .withValues(alpha: 0.38),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
