import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitafolio/features/experience/presentation/viewmodels/experience_viewmodel.dart';
import 'package:vitafolio/features/experience/presentation/widgets/experience_form.dart';
import 'package:vitafolio/features/experience/presentation/widgets/footer_action_bar.dart';
import 'package:vitafolio/features/experience/presentation/widgets/responsibilities_editor.dart';
import 'package:vitafolio/features/experience/presentation/widgets/resume_progress_stepper.dart';

/// Add or Edit Experience Page (Step 4 of 9) matching LinkedIn/Zety design standards.
class AddExperiencePage extends ConsumerStatefulWidget {
  final bool isEditing;
  final MockExperienceItem? initialItem;

  const AddExperiencePage({
    super.key,
    this.isEditing = false,
    this.initialItem,
  });

  @override
  ConsumerState<AddExperiencePage> createState() => _AddExperiencePageState();
}

class _AddExperiencePageState extends ConsumerState<AddExperiencePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _responsibilitiesController;

  String? _selectedEmploymentType;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;
  String? _selectedLocation;
  String? _fromDate;
  String? _toDate;
  bool _isCurrentlyWorking = true;


  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _jobTitleController = TextEditingController(text: item?.title ?? '');
    _companyController = TextEditingController(text: item?.company ?? '');
    _responsibilitiesController =
        TextEditingController(text: item?.responsibilities ?? '');

    _selectedEmploymentType = item?.employmentType ?? 'Full Time';
    _selectedLocation = item?.location ?? 'Bengaluru, India';
    _isCurrentlyWorking = item?.isCurrent ?? true;

    if (item != null && item.location.isNotEmpty) {
      final locParts = item.location.split(', ');
      if (locParts.length >= 2) {
        _selectedCity = locParts[0];
        _selectedCountry = locParts.last;
      } else {
        _selectedCity = item.location;
      }
    }

    if (item != null && item.dateRange.isNotEmpty) {
      final parts = item.dateRange.split(' - ');
      _fromDate = parts.isNotEmpty ? parts[0] : 'Jan 2023';
      if (parts.length > 1 && parts[1] != 'Present') {
        _toDate = parts[1];
      }
    } else {
      _fromDate = 'Jan 2023';
    }
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _responsibilitiesController.dispose();
    super.dispose();
  }

  void _handleCancel() {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/experience');
    }
  }

  void _handleSave() {
    final title = _jobTitleController.text.trim();
    final company = _companyController.text.trim();
    if (title.isEmpty || company.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter job title and company name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dateStr = _isCurrentlyWorking
        ? '${_fromDate ?? 'Jan 2023'} - Present'
        : '${_fromDate ?? 'Jan 2023'} - ${_toDate ?? 'Present'}';

    final formattedLocation = (_selectedCity != null && _selectedCity!.isNotEmpty)
        ? (_selectedCountry != null && _selectedCountry!.isNotEmpty
            ? '$_selectedCity, $_selectedCountry'
            : _selectedCity!)
        : (_selectedLocation ?? 'Bengaluru, India');

    final newItem = MockExperienceItem(
      id: widget.initialItem?.id ?? 'exp-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      company: company,
      employmentType: _selectedEmploymentType ?? 'Full Time',
      dateRange: dateStr,
      location: formattedLocation,
      isCurrent: _isCurrentlyWorking,
      responsibilities: _responsibilitiesController.text.trim(),
    );

    if (widget.isEditing) {
      ref.read(experienceViewModelProvider.notifier).updateExperience(newItem);
    } else {
      ref.read(experienceViewModelProvider.notifier).addExperience(newItem);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isEditing
            ? 'Experience updated successfully!'
            : 'Experience added successfully!'),
        duration: const Duration(seconds: 1),
      ),
    );

    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/experience');
    }
  }

  void _selectFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fromDate = '${_monthName(picked.month)} ${picked.year}';
      });
    }
  }

  void _selectToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _toDate = '${_monthName(picked.month)} ${picked.year}';
      });
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
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
          widget.isEditing ? 'Edit Experience' : 'Add Experience',
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
            // Step 4 of 9 Progress Stepper
            const ResumeProgressStepper(currentStepIndex: 4),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title & Subtitle
                    Text(
                      'Tell us about your work experience',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Start with your most recent job and describe your responsibilities and achievements.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Main Experience Form Fields
                    ExperienceForm(
                      formKey: _formKey,
                      jobTitleController: _jobTitleController,
                      companyController: _companyController,
                      selectedEmploymentType: _selectedEmploymentType,
                      selectedCountry: _selectedCountry,
                      selectedState: _selectedState,
                      selectedCity: _selectedCity,
                      selectedLocation: _selectedLocation,
                      fromDate: _fromDate,
                      toDate: _toDate,
                      isCurrentlyWorking: _isCurrentlyWorking,
                      responsibilitiesController: _responsibilitiesController,
                      onEmploymentTypeChanged: (type) =>
                          setState(() => _selectedEmploymentType = type),
                      onCountryChanged: (c) => setState(() {
                        _selectedCountry = c;
                        _selectedState = null;
                        _selectedCity = null;
                      }),
                      onStateChanged: (st) => setState(() {
                        _selectedState = st;
                        _selectedCity = null;
                      }),
                      onCityChanged: (city) => setState(() {
                        _selectedCity = city;
                      }),
                      onLocationChanged: (location) =>
                          setState(() => _selectedLocation = location),
                      onCurrentlyWorkingChanged: (val) =>
                          setState(() => _isCurrentlyWorking = val),
                      onSelectFromDate: _selectFromDate,
                      onSelectToDate: _selectToDate,
                      onResponsibilitiesChanged: (val) => setState(() {}),
                    ),

                    // Responsibilities & Achievements Multiline Editor with Live Counter
                    ResponsibilitiesEditor(
                      controller: _responsibilitiesController,
                      onChanged: (val) => setState(() {}),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Action Bar (Cancel / Save)
            FooterActionBar(
              onCancel: _handleCancel,
              onSave: _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}
