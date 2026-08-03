import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/constants/app_strings.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/shared/widgets/buttons/primary_button.dart';
import 'package:vitafolio/shared/widgets/inputs/app_text_field.dart';
import 'package:vitafolio/features/workflow/view_model/workflow_view_model.dart';
import 'package:vitafolio/features/workflow/widgets/discard_changes_dialog.dart';
import 'package:vitafolio/features/editor/sections/certifications_section.dart';
import 'package:vitafolio/features/editor/sections/education_section.dart';
import 'package:vitafolio/features/editor/sections/experience_section.dart';
import 'package:vitafolio/features/editor/sections/languages_section.dart';
import 'package:vitafolio/features/editor/sections/personal_info_section.dart';
import 'package:vitafolio/features/editor/sections/projects_section.dart';
import 'package:vitafolio/features/editor/sections/skills_section.dart';
import 'package:vitafolio/features/editor/sections/summary_section.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _preview() {
    final workflowState = ref.read(workflowViewModelProvider);
    if (workflowState.resumeName.trim().isNotEmpty &&
        (workflowState.personalInfo.fullName?.trim().isNotEmpty ?? false) &&
        (workflowState.personalInfo.email?.trim().isNotEmpty ?? false)) {
      context.push(AppRoutes.preview);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill out required fields (Resume Name, Full Name, Email) before previewing.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _onBack() async {
    final state = ref.read(workflowViewModelProvider);
    if (state.hasUnsavedChanges) {
      final shouldDiscard = await showDiscardChangesDialog(context: context);
      return shouldDiscard;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final workflowState = ref.watch(workflowViewModelProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldDiscard = await _onBack();
        if (shouldDiscard && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            workflowState.resumeName.isNotEmpty
                ? workflowState.resumeName
                : AppStrings.resumeEditor,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldDiscard = await _onBack();
              if (shouldDiscard && context.mounted) {
                context.pop();
              }
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: PrimaryButton(
            onPressed: _preview,
            label: AppStrings.previewResume,
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Scrollbar(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                ),
                children: [
                  AppTextField(
                    label: 'Resume Name',
                    initialValue: workflowState.resumeName,
                    onChanged: (value) => ref
                        .read(workflowViewModelProvider.notifier)
                        .updateResumeName(value),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Resume name is required'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const PersonalInformationSection(),
                  const SizedBox(height: AppSpacing.md),
                  const ProfessionalSummarySection(),
                  const SizedBox(height: AppSpacing.md),
                  const EducationSection(),
                  const SizedBox(height: AppSpacing.md),
                  const ExperienceSection(),
                  const SizedBox(height: AppSpacing.md),
                  const SkillsSection(),
                  const SizedBox(height: AppSpacing.md),
                  const ProjectsSection(),
                  const SizedBox(height: AppSpacing.md),
                  const CertificationsSection(),
                  const SizedBox(height: AppSpacing.md),
                  const LanguagesSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
