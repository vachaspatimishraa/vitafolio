import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/features/preview/view_model/preview_view_model.dart';
import 'package:vitafolio/features/preview/widgets/preview_loading_view.dart';

class ResumeCanvas extends ConsumerWidget {
  const ResumeCanvas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previewState = ref.watch(previewViewModelProvider);

    if (previewState.isLoading) {
      return const PreviewLoadingView();
    }

    if (previewState.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                previewState.errorMessage ?? 'Failed to load preview',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ref
                      .read(previewViewModelProvider.notifier)
                      .loadActiveResume();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final domainResume = previewState.resume;
    if (domainResume == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No Resume Selected',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a new resume or select an existing resume to preview.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final selectedTemplateId = domainResume.selectedTemplateId.value.isNotEmpty
        ? domainResume.selectedTemplateId.value
        : 'ats';

    final workflowState = PdfService.workflowStateFromDomain(domainResume);
    final pdfRenderer = PdfService().resolveRenderer(selectedTemplateId);

    return SingleChildScrollView(
      key: ValueKey('${domainResume.selectedTemplateId.value}_${domainResume.fontFamily}'),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: pdfRenderer.buildPreview(workflowState, context),
        ),
      ),
    );
  }
}

