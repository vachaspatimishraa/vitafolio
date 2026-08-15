import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/languages/presentation/viewmodels/languages_viewmodel.dart';
import 'package:vitafolio/features/languages/presentation/widgets/empty_language_state.dart';
import 'package:vitafolio/features/languages/presentation/widgets/footer_action_bar.dart';
import 'package:vitafolio/features/languages/presentation/widgets/language_card.dart';
import 'package:vitafolio/features/languages/presentation/widgets/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/section_add_button.dart';

/// Screen displaying list of added languages (Step 8 of 9).
class LanguagesPage extends ConsumerWidget {
  const LanguagesPage({super.key});

  void _handlePrevious(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.certifications);
    }
  }

  void _handleContinue(BuildContext context) {
    context.push(AppRoutes.review);
  }

  void _handleAddLanguage(BuildContext context) {
    context.push(AppRoutes.addLanguage);
  }

  void _handleEditLanguage(
    BuildContext context,
    MockLanguageItem item,
  ) {
    context.push(
      AppRoutes.addLanguage,
      extra: {
        'isEditing': true,
        'item': item,
      },
    );
  }

  void _handleDeleteLanguage(BuildContext context, WidgetRef ref, String id) {
    ref.read(languagesViewModelProvider.notifier).deleteLanguage(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Language removed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(languagesViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _handlePrevious(context),
        ),
        title: const Text(
          'Languages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
        child: Column(
          children: [
            // Resume Progress Stepper (Step 8 of 9)
            const ResumeProgressStepper(currentStepIndex: 9),

            // Main Scrollable Area
            Expanded(
              child: state.languages.isEmpty
                  ? EmptyLanguageState(onAdd: () => _handleAddLanguage(context))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          Text(
                            'Languages You Speak',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Add languages you are fluent or proficient in to enhance global reach.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Language Cards List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.languages.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (context, index) {
                              final lang = state.languages[index];
                              return LanguageCard(
                                language: lang.language,
                                level: lang.level,
                                onEdit: () =>
                                    _handleEditLanguage(context, lang),
                                onDelete: () => _handleDeleteLanguage(
                                  context,
                                  ref,
                                  lang.id,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          SectionAddButton(
                            label: 'Add Language',
                            onPressed: () => _handleAddLanguage(context),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),

            // Sticky Footer Navigation Action Bar
            FooterActionBar(
              onPrevious: () => _handlePrevious(context),
              onContinue: () => _handleContinue(context),
              isLoading: state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
