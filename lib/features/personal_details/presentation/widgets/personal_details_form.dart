import 'package:flutter/material.dart';
import 'package:vitafolio/core/data/job_role_data.dart';
import 'package:vitafolio/features/experience/presentation/widgets/cascading_location_data.dart';
import 'package:vitafolio/features/personal_details/presentation/widgets/hybrid_search_dropdown.dart';

/// Form containing Personal Details input fields.
/// ONLY Full Name and Phone Number are mandatory (*).
/// Everything else is optional.
class PersonalDetailsForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController jobRoleController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController linkedinController;
  final TextEditingController githubController;
  final TextEditingController websiteController;
  final String? selectedCountry;
  final String? selectedCity;
  final String? selectedState;
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;

  const PersonalDetailsForm({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.jobRoleController,
    required this.phoneController,
    required this.emailController,
    required this.linkedinController,
    required this.githubController,
    required this.websiteController,
    this.selectedCountry,
    required this.selectedState,
    required this.selectedCity,
    required this.onCountryChanged,
    required this.onStateChanged,
    required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final countries = CascadingLocationData.getCountries();
    final states = CascadingLocationData.getStates(selectedCountry);
    final cities = CascadingLocationData.getCities(selectedCountry, selectedState);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name * (REQUIRED)
          TextFormField(
            controller: fullNameController,
            decoration: InputDecoration(
              labelText: 'Full Name *',
              hintText: 'e.g. John Doe',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Job Role (OPTIONAL)
          HybridSearchDropdown(
            label: 'Job Role',
            initialValue: jobRoleController.text.isNotEmpty
                ? jobRoleController.text
                : null,
            items: kGlobalJobRoleCatalogue,
            onChanged: (value) {
              jobRoleController.text = value;
            },
          ),
          const SizedBox(height: 16),

          // Phone Number * (REQUIRED)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 124,
                margin: const EdgeInsets.only(right: 8),
                child: DropdownButtonFormField<String>(
                  initialValue: '+91',
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  decoration: InputDecoration(
                    labelText: 'Code',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: '+91', child: Text('🇮🇳 +91', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: '+1', child: Text('🇺🇸 +1', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: '+44', child: Text('🇬🇧 +44', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: '+61', child: Text('🇦🇺 +61', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: '+49', child: Text('🇩🇪 +49', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: '+33', child: Text('🇫🇷 +33', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: '+971', child: Text('🇦🇪 +971', style: TextStyle(fontSize: 13))),
                    DropdownMenuItem(value: '+65', child: Text('🇸กัด +65', style: TextStyle(fontSize: 13))),
                  ],
                  onChanged: (val) {},
                ),
              ),

              Expanded(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: '9876543210',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    final cleaned = value.trim().replaceAll(RegExp(r'\s+'), '');
                    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
                      return 'Phone number must contain only digits';
                    }
                    if (cleaned.length != 10) {
                      return 'Phone number must contain 10 digits.';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Email Address (OPTIONAL - validated only if non-empty)
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'john@example.com',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null; // Optional
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Country (OPTIONAL)
          HybridSearchDropdown(
            label: 'Country',
            initialValue: selectedCountry,
            items: countries,
            onChanged: onCountryChanged,
          ),
          const SizedBox(height: 16),

          // State / Region (OPTIONAL)
          HybridSearchDropdown(
            label: 'State / Region',
            initialValue: selectedState,
            items: states,
            onChanged: onStateChanged,
          ),
          const SizedBox(height: 16),

          // City (OPTIONAL)
          HybridSearchDropdown(
            label: 'City',
            initialValue: selectedCity,
            items: cities,
            onChanged: onCityChanged,
          ),
          const SizedBox(height: 24),

          // Social Links Section Header
          Text(
            'Social & Online Profiles',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),

          // LinkedIn (OPTIONAL)
          TextFormField(
            controller: linkedinController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'LinkedIn Profile',
              hintText: 'https://linkedin.com/in/username',
              prefixIcon: const Icon(Icons.link_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              final val = value.trim();
              if (!val.contains('linkedin.com/')) {
                return 'Please enter a valid LinkedIn profile URL.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // GitHub (OPTIONAL)
          TextFormField(
            controller: githubController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'GitHub Profile',
              hintText: 'https://github.com/username',
              prefixIcon: const Icon(Icons.code_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              final val = value.trim();
              if (!val.contains('github.com/')) {
                return 'Please enter a valid GitHub profile URL.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Portfolio / Website (OPTIONAL)
          TextFormField(
            controller: websiteController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: 'Portfolio / Website',
              hintText: 'https://portfolio.com',
              prefixIcon: const Icon(Icons.language_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              final val = value.trim();
              final urlRegex = RegExp(r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/.*)?$');
              if (!urlRegex.hasMatch(val)) {
                return 'Please enter a valid website URL.';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
