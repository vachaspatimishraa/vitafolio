import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../features/workflow/view_model/workflow_view_model.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../widgets/editor_section.dart';

class PersonalInformationSection extends ConsumerWidget {
  const PersonalInformationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowViewModelProvider);
    final info = state.personalInfo;

    return EditorSection(
      title: 'Personal Information',
      child: Column(
        children: [
          AppTextField(
            label: 'Full Name',
            initialValue: info.fullName,
            onChanged: (value) => ref
                .read(workflowViewModelProvider.notifier)
                .updatePersonalInfo(info.copyWith(fullName: value)),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Full name is required'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Job Title',
            initialValue: info.jobTitle,
            onChanged: (value) => ref
                .read(workflowViewModelProvider.notifier)
                .updatePersonalInfo(info.copyWith(jobTitle: value)),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Email',
            initialValue: info.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => ref
                .read(workflowViewModelProvider.notifier)
                .updatePersonalInfo(info.copyWith(email: value)),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) {
                return 'Email is required';
              }
              return ref
                      .read(workflowViewModelProvider.notifier)
                      .isValidEmail(text)
                  ? null
                  : 'Enter a valid email';
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Phone',
            initialValue: info.phone,
            keyboardType: TextInputType.phone,
            onChanged: (value) => ref
                .read(workflowViewModelProvider.notifier)
                .updatePersonalInfo(info.copyWith(phone: value)),
            validator: (value) {
              final text = value?.trim() ?? '';
              return ref
                      .read(workflowViewModelProvider.notifier)
                      .isValidPhone(text)
                  ? null
                  : 'Enter a valid phone number';
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Address',
            initialValue: info.address,
            onChanged: (value) => ref
                .read(workflowViewModelProvider.notifier)
                .updatePersonalInfo(info.copyWith(address: value)),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'City',
                  initialValue: info.city,
                  onChanged: (value) => ref
                      .read(workflowViewModelProvider.notifier)
                      .updatePersonalInfo(info.copyWith(city: value)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  label: 'State',
                  initialValue: info.state,
                  onChanged: (value) => ref
                      .read(workflowViewModelProvider.notifier)
                      .updatePersonalInfo(info.copyWith(state: value)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Country',
                  initialValue: info.country,
                  onChanged: (value) => ref
                      .read(workflowViewModelProvider.notifier)
                      .updatePersonalInfo(info.copyWith(country: value)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  label: 'LinkedIn',
                  initialValue: info.linkedIn,
                  keyboardType: TextInputType.url,
                  onChanged: (value) => ref
                      .read(workflowViewModelProvider.notifier)
                      .updatePersonalInfo(info.copyWith(linkedIn: value)),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    return ref
                            .read(workflowViewModelProvider.notifier)
                            .isValidUrl(text)
                        ? null
                        : 'Enter a valid URL';
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'GitHub',
                  initialValue: info.github,
                  keyboardType: TextInputType.url,
                  onChanged: (value) => ref
                      .read(workflowViewModelProvider.notifier)
                      .updatePersonalInfo(info.copyWith(github: value)),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    return ref
                            .read(workflowViewModelProvider.notifier)
                            .isValidUrl(text)
                        ? null
                        : 'Enter a valid URL';
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  label: 'Portfolio Website',
                  initialValue: info.portfolio,
                  keyboardType: TextInputType.url,
                  onChanged: (value) => ref
                      .read(workflowViewModelProvider.notifier)
                      .updatePersonalInfo(info.copyWith(portfolio: value)),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    return ref
                            .read(workflowViewModelProvider.notifier)
                            .isValidUrl(text)
                        ? null
                        : 'Enter a valid URL';
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
