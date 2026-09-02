import 'package:flutter/material.dart';
import 'package:vitafolio/core/utils/employment_type_helper.dart';
import 'package:vitafolio/features/experience/presentation/widgets/cascading_location_data.dart';
import 'package:vitafolio/features/personal_details/presentation/widgets/hybrid_search_dropdown.dart';

/// Form containing inputs for adding or editing work experience details.
class ExperienceForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController jobTitleController;
  final TextEditingController companyController;
  final String? selectedEmploymentType;
  final String? selectedCountry;
  final String? selectedState;
  final String? selectedCity;
  final String? selectedLocation;
  final String? fromDate;
  final String? toDate;
  final bool isCurrentlyWorking;
  final TextEditingController responsibilitiesController;
  final ValueChanged<String?> onEmploymentTypeChanged;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<bool> onCurrentlyWorkingChanged;
  final VoidCallback onSelectFromDate;
  final VoidCallback onSelectToDate;
  final ValueChanged<String> onResponsibilitiesChanged;

  static const List<String> kEmploymentTypes = [
    'Full Time',
    'Part Time',
    'Internship',
    'Contract',
    'Freelance',
    'Temporary',
  ];

  const ExperienceForm({
    super.key,
    required this.formKey,
    required this.jobTitleController,
    required this.companyController,
    required this.selectedEmploymentType,
    this.selectedCountry,
    this.selectedState,
    this.selectedCity,
    required this.selectedLocation,
    required this.fromDate,
    required this.toDate,
    required this.isCurrentlyWorking,
    required this.responsibilitiesController,
    required this.onEmploymentTypeChanged,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.onLocationChanged,
    required this.onCurrentlyWorkingChanged,
    required this.onSelectFromDate,
    required this.onSelectToDate,
    required this.onResponsibilitiesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final countries = CascadingLocationData.getCountries();
    final states = CascadingLocationData.getStates(selectedCountry);
    final cities = CascadingLocationData.getCities(selectedCountry, selectedState);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Title *
          TextFormField(
            controller: jobTitleController,
            decoration: InputDecoration(
              labelText: 'Job Title *',
              hintText: 'e.g. Senior Flutter Developer',
              prefixIcon: const Icon(Icons.work_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Company Name *
          TextFormField(
            controller: companyController,
            decoration: InputDecoration(
              labelText: 'Company Name *',
              hintText: 'e.g. Google',
              prefixIcon: const Icon(Icons.business_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),

          // Employment Type Dropdown
          DropdownButtonFormField<String>(
            initialValue: EmploymentTypeHelper.getSafeDropdownValue(
              selectedEmploymentType,
              kEmploymentTypes,
            ),
            decoration: InputDecoration(
              labelText: 'Employment Type',
              prefixIcon: const Icon(Icons.badge_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: kEmploymentTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: onEmploymentTypeChanged,
          ),
          const SizedBox(height: 16),

          // Cascading Country Dropdown (Full width)
          HybridSearchDropdown(
            label: 'Country',
            initialValue: selectedCountry,
            items: countries,
            onChanged: onCountryChanged,
          ),
          const SizedBox(height: 16),

          // Cascading State / Region Dropdown (Full width)
          HybridSearchDropdown(
            label: 'State / Region',
            initialValue: selectedState,
            items: states,
            onChanged: onStateChanged,
          ),
          const SizedBox(height: 16),

          // Cascading City Dropdown (Full width)
          HybridSearchDropdown(
            label: 'City',
            initialValue: selectedCity,
            items: cities,
            onChanged: onCityChanged,
          ),

          const SizedBox(height: 16),

          // Currently Working Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_box_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'I am currently working here',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: isCurrentlyWorking,
                  onChanged: onCurrentlyWorkingChanged,
                  activeThumbColor: colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // From Date & To Date Row
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onSelectFromDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'From Date *',
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      fromDate ?? 'Select Date',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: fromDate != null
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: !isCurrentlyWorking ? onSelectToDate : null,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'To Date *',
                      enabled: !isCurrentlyWorking,
                      prefixIcon: const Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: isCurrentlyWorking,
                      fillColor: isCurrentlyWorking
                          ? colorScheme.surfaceContainerHigh
                          : null,
                    ),
                    child: Text(
                      isCurrentlyWorking ? 'Present' : (toDate ?? 'Select Date'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isCurrentlyWorking
                            ? colorScheme.primary
                            : (toDate != null
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant),
                        fontWeight: isCurrentlyWorking
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
