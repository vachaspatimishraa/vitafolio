import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/router.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../workflow/widgets/discard_changes_dialog.dart';
import '../view_model/editor_view_model.dart';
import '../widgets/save_status_indicator.dart';
import '../widgets/validation_banner.dart';
import '../widgets/editor_loading_view.dart';

// Sections
import '../sections/certifications_section.dart';
import '../sections/education_section.dart';
import '../sections/experience_section.dart';
import '../sections/languages_section.dart';
import '../sections/personal_info_section.dart';
import '../sections/projects_section.dart';
import '../sections/summary_section.dart';
import '../sections/skills_section.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _preview() {
    final isValid = ref.read(editorViewModelProvider.notifier).validate();
    if (isValid) {
      context.push(AppRoutes.preview);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all required fields (Resume Name, Full Name, and Email) before previewing.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _onBack() async {
    final state = ref.read(editorViewModelProvider);
    if (state.hasUnsavedChanges) {
      final shouldDiscard = await showDiscardChangesDialog(context: context);
      if (shouldDiscard) {
        return true;
      }
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorViewModelProvider);

    if (editorState.isLoading) {
      return const EditorLoadingView();
    }

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
          title: Text(editorState.resume?.title ?? AppStrings.resumeEditor),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final shouldDiscard = await _onBack();
              if (shouldDiscard && context.mounted) {
                context.pop();
              }
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SaveStatusIndicator(status: editorState.saveStatus),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: PrimaryButton(
            onPressed: _preview,
            label: AppStrings.previewResume,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ValidationBanner(errors: editorState.validationErrors),
              Expanded(
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
                          initialValue: editorState.resume?.title ?? '',
                          onChanged: (value) => ref
                              .read(editorViewModelProvider.notifier)
                              .renameActiveResume(value),
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
            ],
          ),
        ),
      ),
    );
  }
}
