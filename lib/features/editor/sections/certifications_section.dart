import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../features/workflow/view_model/workflow_view_model.dart';
import '../../../shared/widgets/buttons/icon_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/inputs/date_picker_field.dart';
import '../widgets/editor_section.dart';

class CertificationsSection extends ConsumerWidget {
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowViewModelProvider);

    return EditorSection(
      title: 'Certifications',
      trailing: SecondaryButton(
        label: AppStrings.addCertification,
        icon: Icons.add,
        onPressed: () => ref.read(workflowViewModelProvider.notifier).addCertification(),
      ),
      child: Column(
        children: [
          for (var index = 0; index < state.certifications.length; index++) ...[
            _CertificationCard(key: ValueKey(state.certifications[index].id), index: index),
            if (index < state.certifications.length - 1) const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _CertificationCard extends ConsumerWidget {
  final int index;

  const _CertificationCard({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(workflowViewModelProvider).certifications[index];
    final notifier = ref.read(workflowViewModelProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Certification ${index + 1}', style: Theme.of(context).textTheme.titleSmall),
                ),
                AppIconButton(
                  icon: Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                  tooltip: 'Delete item',
                  onPressed: () => notifier.removeCertification(index),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Certification Name',
              initialValue: item.title,
              onChanged: (value) => notifier.updateCertification(index, item.copyWith(title: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Organization',
              initialValue: item.subtitle,
              onChanged: (value) => notifier.updateCertification(index, item.copyWith(subtitle: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            DatePickerField(
              label: 'Date',
              initialValue: item.startDate,
              onChanged: (value) => notifier.updateCertification(index, item.copyWith(startDate: value)),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Credential URL',
              initialValue: item.url,
              keyboardType: TextInputType.url,
              onChanged: (value) => notifier.updateCertification(index, item.copyWith(url: value)),
              validator: (value) {
                final text = value?.trim() ?? '';
                return ref.read(workflowViewModelProvider.notifier).isValidUrl(text) ? null : 'Enter a valid URL';
              },
            ),
          ],
        ),
      ),
    );
  }
}
