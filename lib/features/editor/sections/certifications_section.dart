import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/shared/widgets/buttons/icon_button.dart';
import 'package:vitafolio/shared/widgets/buttons/secondary_button.dart';
import 'package:vitafolio/shared/widgets/inputs/app_text_field.dart';
import 'package:vitafolio/shared/widgets/inputs/date_picker_field.dart';
import 'package:vitafolio/features/editor/widgets/editor_section.dart';

class CertificationsSection extends ConsumerWidget {
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final certificationsLength = ref.watch(
      workflowViewModelProvider.select((state) => state.certifications.length),
    );

    return EditorSection(
      title: 'Certifications',
      trailing: SecondaryButton(
        label: AppStrings.addCertification,
        icon: Icons.add,
        onPressed: () =>
            ref.read(workflowViewModelProvider.notifier).addCertification(),
      ),
      child: Column(
        children: [
          for (var index = 0; index < certificationsLength; index++) ...[
            _CertificationCard(
              key: ValueKey(
                ref.watch(
                  workflowViewModelProvider.select(
                    (s) => s.certifications[index].id,
                  ),
                ),
              ),
              index: index,
            ),
            if (index < certificationsLength - 1)
              const SizedBox(height: AppSpacing.md),
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
    final item = ref.watch(
      workflowViewModelProvider.select((state) => state.certifications[index]),
    );
    final notifier = ref.read(workflowViewModelProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Certification ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
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
              initialValue: item.certificateName,
              onChanged: (value) => notifier.updateCertification(
                index,
                item.copyWith(certificateName: value),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Organization',
              initialValue: item.organization,
              onChanged: (value) => notifier.updateCertification(
                index,
                item.copyWith(organization: value),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DatePickerField(
              label: 'Date',
              initialValue: item.issueDate?.toIso8601String().split('T').first,
              onChanged: (value) => notifier.updateCertification(
                index,
                item.copyWith(issueDate: DateTime.tryParse(value)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Credential URL',
              initialValue: item.credentialUrl,
              keyboardType: TextInputType.url,
              onChanged: (value) => notifier.updateCertification(
                index,
                item.copyWith(credentialUrl: value),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                return ref
                        .read(workflowViewModelProvider.notifier)
                        .isValidUrl(text)
                    ? null
                    : 'Enter a valid URL';
              },
            ),
          ],
        ),
      ),
    );
  }
}
