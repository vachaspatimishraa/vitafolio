import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../features/workflow/view_model/workflow_view_model.dart';
import '../widgets/editor_section.dart';
import '../../../shared/widgets/inputs/multiline_field.dart';

class ProfessionalSummarySection extends ConsumerWidget {
  const ProfessionalSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(
      workflowViewModelProvider.select((state) => state.summary),
    );

    return EditorSection(
      title: 'Professional Summary',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MultilineField(
            label: 'Summary',
            hintText:
                'Write a concise professional summary that highlights your strengths.',
            initialValue: summary,
            maxLength: WorkflowViewModel.summaryCharacterLimit,
            onChanged: (value) => ref
                .read(workflowViewModelProvider.notifier)
                .updateSummary(value),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${summary.length}/${WorkflowViewModel.summaryCharacterLimit} characters',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
