import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/features/languages/presentation/viewmodels/languages_viewmodel.dart';
import 'package:vitafolio/features/languages/presentation/widgets/hybrid_language_dropdown.dart';
import 'package:vitafolio/features/languages/presentation/widgets/language_level_dropdown.dart';
import 'package:vitafolio/features/languages/presentation/widgets/resume_progress_stepper.dart';
import 'package:vitafolio/shared/widgets/helpers/sticky_bottom_navigation.dart';

/// Dedicated Add / Edit Language Details Screen (Step 8 of 9).
class AddLanguagePage extends ConsumerStatefulWidget {
  final bool isEditing;
  final MockLanguageItem? initialLanguage;

  const AddLanguagePage({
    super.key,
    this.isEditing = false,
    this.initialLanguage,
  });

  @override
  ConsumerState<AddLanguagePage> createState() => _AddLanguagePageState();
}

class _AddLanguagePageState extends ConsumerState<AddLanguagePage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedLanguage;
  String? _selectedProficiency;
  String? _languageError;
  String? _proficiencyError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialLanguage;
    if (item != null) {
      _selectedLanguage = item.language;
      _selectedProficiency = item.level;
    }
  }

  void _handleCancel() {
    FocusScope.of(context).unfocus();
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.languages);
    }
  }

  String _getStarRating(String? level) {
    if (level == null || level.trim().isEmpty) return '';
    final l = level.trim().toLowerCase();
    if (l.contains('beginner')) return '★☆☆☆☆';
    if (l.contains('elementary')) return '★★☆☆☆';
    if (l.contains('intermediate') && !l.contains('upper')) return '★★★☆☆';
    if (l.contains('upper intermediate')) return '★★★★☆';
    if (l.contains('advanced')) return '★★★★☆';
    if (l.contains('professional')) return '★★★★★';
    if (l.contains('native') || l.contains('bilingual')) return '★★★★★';
    return '★★★☆☆';
  }

  void _handleSave() {
    FocusScope.of(context).unfocus();

    setState(() {
      _languageError = null;
      _proficiencyError = null;
    });

    final lang = _selectedLanguage?.trim() ?? '';
    final level = _selectedProficiency?.trim() ?? '';

    bool hasError = false;

    if (lang.isEmpty) {
      setState(() {
        _languageError = 'Language is required';
      });
      hasError = true;
    }

    if (level.isEmpty) {
      setState(() {
        _proficiencyError = 'Proficiency level is required';
      });
      hasError = true;
    }

    if (hasError) return;

    // Check duplicate language
    final existingList = ref.read(languagesViewModelProvider).languages;
    final currentId = widget.initialLanguage?.id;

    final isDuplicate = existingList.any((item) {
      if (widget.isEditing && item.id == currentId) return false;
      return item.language.trim().toLowerCase() == lang.toLowerCase();
    });

    if (isDuplicate) {
      setState(() {
        _languageError = '$lang has already been added.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final newItem = MockLanguageItem(
      id: currentId ?? 'lang-${DateTime.now().millisecondsSinceEpoch}',
      language: lang,
      level: level,
    );

    if (widget.isEditing) {
      ref.read(languagesViewModelProvider.notifier).updateLanguage(newItem);
    } else {
      ref.read(languagesViewModelProvider.notifier).addLanguage(newItem);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditing
              ? 'Language updated successfully'
              : 'Language added successfully',
        ),
        duration: const Duration(seconds: 1),
      ),
    );

    _handleCancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasPreviewData = (_selectedLanguage != null &&
            _selectedLanguage!.trim().isNotEmpty) ||
        (_selectedProficiency != null &&
            _selectedProficiency!.trim().isNotEmpty);

    final stars = _getStarRating(_selectedProficiency);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleCancel,
        ),
        title: Text(
          widget.isEditing ? 'Edit Language' : 'Add Language',
          style: const TextStyle(fontWeight: FontWeight.bold),
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
            // Progress Stepper (Step 8 of 9)
            const ResumeProgressStepper(currentStepIndex: 9),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Text(
                        'Language Details',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Add languages you know and specify your proficiency level.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Language Hybrid Selector
                      HybridLanguageDropdown(
                        label: 'Language *',
                        initialValue: _selectedLanguage,
                        errorText: _languageError,
                        onChanged: (val) {
                          setState(() {
                            _selectedLanguage = val;
                            _languageError = null;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Proficiency Hybrid Selector
                      LanguageLevelDropdown(
                        label: 'Proficiency Level *',
                        initialValue: _selectedProficiency,
                        errorText: _proficiencyError,
                        onChanged: (val) {
                          setState(() {
                            _selectedProficiency = val;
                            _proficiencyError = null;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Live Preview Section
                      Text(
                        'Language Preview',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: hasPreviewData
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(
                                        AppSpacing.sm),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer
                                          .withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.language_outlined,
                                      size: 24,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _selectedLanguage?.isNotEmpty == true
                                              ? _selectedLanguage!
                                              : 'Select a language',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        const SizedBox(
                                            height: AppSpacing.xxs),
                                        Text(
                                          _selectedProficiency?.isNotEmpty ==
                                                  true
                                              ? _selectedProficiency!
                                              : 'Select proficiency...',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color:
                                                colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        if (stars.isNotEmpty) ...[
                                          const SizedBox(
                                              height: AppSpacing.xs),
                                          Text(
                                            stars,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: colorScheme.primary,
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.md),
                                child: Center(
                                  child: Text(
                                    'Select a language and proficiency level to preview your entry.',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Action Footer (Cancel / Save Language)
            StickyBottomNavigation(
              secondaryLabel: 'Cancel',
              onSecondaryPressed: _handleCancel,
              primaryLabel:
                  widget.isEditing ? 'Update Language' : 'Save Language',
              onPrimaryPressed: _isSaving ? null : _handleSave,
              isPrimaryLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}
