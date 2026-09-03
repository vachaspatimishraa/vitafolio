import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';
import 'package:vitafolio/app/router.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/features/education/presentation/viewmodels/education_viewmodel.dart';
import 'package:vitafolio/features/education/presentation/widgets/current_study_switch.dart';
import 'package:vitafolio/features/education/presentation/widgets/description_editor.dart';
import 'package:vitafolio/features/education/presentation/widgets/education_form.dart';
import 'package:vitafolio/features/experience/presentation/widgets/cascading_location_data.dart';
import 'package:vitafolio/shared/widgets/helpers/sticky_bottom_navigation.dart';

import 'package:vitafolio/features/personal_details/presentation/widgets/hybrid_search_dropdown.dart';
import 'package:vitafolio/features/education/presentation/widgets/resume_progress_stepper.dart';

import 'package:vitafolio/features/education/presentation/widgets/year_picker_field.dart';

const List<String> kMockCities = [
  'New Delhi',
  'Mumbai',
  'Bengaluru',
  'San Francisco',
  'New York',
  'London',
];

const List<String> kMockStates = [
  'Delhi',
  'Maharashtra',
  'Karnataka',
  'California',
  'New York',
];

/// Screen assembling Add / Edit Education using Antigravity reusable widgets.
class AddEducationPage extends ConsumerStatefulWidget {
  final bool isEditing;
  final MockEducationItem? initialItem;

  const AddEducationPage({
    super.key,
    this.isEditing = false,
    this.initialItem,
  });

  @override
  ConsumerState<AddEducationPage> createState() => _AddEducationPageState();
}

class _AddEducationPageState extends ConsumerState<AddEducationPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _degreeController;
  late TextEditingController _fieldOfStudyController;
  late TextEditingController _institutionController;
  late TextEditingController _gradeController;
  late TextEditingController _descriptionController;

  String? _selectedStartYear;
  String? _selectedEndYear;
  String? _startYearError;
  String? _endYearError;
  String? _selectedCountry;
  String? _selectedCity;
  String? _selectedState;

  bool _isCurrentlyStudying = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;

    _degreeController = TextEditingController(
      text: widget.isEditing ? (item?.degree ?? 'Bachelor of Technology') : '',
    );
    _fieldOfStudyController = TextEditingController(
      text: widget.isEditing
          ? (item?.fieldOfStudy ?? 'Computer Science & Engineering')
          : '',
    );
    _institutionController = TextEditingController(
      text: widget.isEditing
          ? (item?.institution ?? 'Indian Institute of Technology')
          : '',
    );
    _gradeController = TextEditingController(
      text: widget.isEditing ? (item?.grade ?? '8.6 CGPA') : '',
    );
    _descriptionController = TextEditingController(
      text: widget.isEditing
          ? (item?.description ??
              'Focused on Software Engineering, Data Structures, Algorithms, and Mobile Development.')
          : '',
    );

    if (widget.isEditing) {
      if (item != null && item.dateRange.isNotEmpty) {
        final isPursuing =
            item.dateRange.contains('Pursuing') || item.dateRange.contains('Present');
        _isCurrentlyStudying = isPursuing;

        if (item.dateRange.contains(' - ')) {
          final dates = item.dateRange.split(' - ');
          _selectedStartYear = (dates.isNotEmpty && dates[0].trim().isNotEmpty)
              ? dates[0].trim()
              : null;
          _selectedEndYear = (dates.length > 1 &&
                  dates[1].trim().isNotEmpty &&
                  !isPursuing)
              ? dates[1].trim()
              : null;
        } else if (item.dateRange.contains(' – ')) {
          final dates = item.dateRange.split(' – ');
          _selectedStartYear = (dates.isNotEmpty && dates[0].trim().isNotEmpty)
              ? dates[0].trim()
              : null;
          _selectedEndYear = (dates.length > 1 &&
                  dates[1].trim().isNotEmpty &&
                  !isPursuing)
              ? dates[1].trim()
              : null;
        } else {
          if (isPursuing) {
            final start = item.dateRange
                .replaceAll('Pursuing', '')
                .replaceAll('Present', '')
                .trim();
            _selectedStartYear = start.isNotEmpty ? start : null;
            _selectedEndYear = null;
          } else {
            _selectedStartYear =
                item.dateRange.trim().isNotEmpty ? item.dateRange.trim() : null;
            _selectedEndYear = null;
          }
        }
      } else {
        _selectedStartYear = null;
        _selectedEndYear = null;
        _isCurrentlyStudying = false;
      }
      _selectedCity = null;
      _selectedState = null;
    }

  }

  @override
  void dispose() {
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    _institutionController.dispose();
    _gradeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleCancel() {
    FocusScope.of(context).unfocus();
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.education);
    }
  }

  void _handleSave() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    String? startErr;
    if (_selectedStartYear == null || _selectedStartYear!.trim().isEmpty) {
      startErr = 'Start year is required';
    }

    String? endErr;
    if (!_isCurrentlyStudying && (_selectedEndYear == null || _selectedEndYear!.trim().isEmpty)) {
      endErr = 'End year is required';
    }

    setState(() {
      _startYearError = startErr;
      _endYearError = endErr;
    });

    if (!isFormValid || startErr != null || endErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields (Degree, Field of Study, Institution)'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final dateRangeText = DateRangeFormatter.formatEducation(
      startYear: _selectedStartYear,
      endYear: _selectedEndYear,
      isCurrentlyStudying: _isCurrentlyStudying,
      separator: ' - ',
    );

    final newItem = MockEducationItem(
      id: widget.initialItem?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      degree: _degreeController.text.trim(),
      fieldOfStudy: _fieldOfStudyController.text.trim(),
      institution: _institutionController.text.trim(),
      dateRange: dateRangeText,
      grade: _gradeController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    if (widget.isEditing) {
      ref.read(educationViewModelProvider.notifier).updateEducation(newItem);
    } else {
      ref.read(educationViewModelProvider.notifier).addEducation(newItem);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditing
              ? 'Education updated successfully'
              : 'Education added successfully',
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleCancel,
        ),
        title: Text(
          widget.isEditing ? 'Edit Education' : 'Add Education',
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
            // Resume Progress Stepper (Step 5 of 9)
            const ResumeProgressStepper(currentStepIndex: 6),

            // Scrollable Assembly Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title & Subtitle
                    Text(
                      widget.isEditing
                          ? 'Edit Qualification'
                          : 'Add Qualification',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Provide details about your degree, institution, and study period.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Core Education Form Fields
                    EducationForm(
                      formKey: _formKey,
                      degreeController: _degreeController,
                      fieldOfStudyController: _fieldOfStudyController,
                      institutionController: _institutionController,
                      gradeController: _gradeController,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Country, State / Region & City Stacked Location Fields
                    HybridSearchDropdown(
                      label: 'Country',
                      initialValue: _selectedCountry,
                      items: CascadingLocationData.getCountries(),
                      onChanged: (country) => setState(() {
                        _selectedCountry = country;
                        _selectedState = null;
                        _selectedCity = null;
                      }),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    HybridSearchDropdown(
                      label: 'State / Region',
                      initialValue: _selectedState,
                      items: CascadingLocationData.getStates(_selectedCountry),
                      onChanged: (state) => setState(() {
                        _selectedState = state;
                        _selectedCity = null;
                      }),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    HybridSearchDropdown(
                      label: 'City',
                      initialValue: _selectedCity,
                      items: CascadingLocationData.getCities(_selectedCountry, _selectedState),
                      onChanged: (city) =>
                          setState(() => _selectedCity = city),
                    ),

                    const SizedBox(height: AppSpacing.md),


                    // Start Year & End Year Pickers
                    Row(
                      children: [
                        Expanded(
                          child: YearPickerField(
                            label: 'Start Year *',
                            value: _selectedStartYear,
                            errorText: _startYearError,
                            onYearSelected: (year) =>
                                setState(() {
                                  _selectedStartYear = year;
                                  _startYearError = null;
                                }),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _isCurrentlyStudying
                              ? Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
                                    border: Border.all(
                                      color: colorScheme.outlineVariant,
                                    ),
                                  ),
                                  child: Text(
                                    'Pursuing',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                )
                              : YearPickerField(
                                  label: _isCurrentlyStudying ? 'End Year' : 'End Year *',
                                  value: _selectedEndYear,
                                  errorText: _endYearError,
                                  onYearSelected: (year) =>
                                      setState(() {
                                        _selectedEndYear = year;
                                        _endYearError = null;
                                      }),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Currently Studying Switch
                    CurrentStudySwitch(
                      value: _isCurrentlyStudying,
                      onChanged: (val) =>
                          setState(() {
                            _isCurrentlyStudying = val;
                            if (val) {
                              _endYearError = null;
                            }
                          }),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Optional Description Editor
                    DescriptionEditor(
                      controller: _descriptionController,
                      onChanged: (text) => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // Sticky Footer Action Bar (Cancel / Save)
            StickyBottomNavigation(
              secondaryLabel: 'Cancel',
              onSecondaryPressed: _handleCancel,
              primaryLabel: 'Save',
              onPrimaryPressed: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
