import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Form component containing Degree, Field of Study, Institution, and Grade text fields.
class EducationForm extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController degreeController;
  final TextEditingController fieldOfStudyController;
  final TextEditingController institutionController;
  final TextEditingController gradeController;

  const EducationForm({
    super.key,
    this.formKey,
    required this.degreeController,
    required this.fieldOfStudyController,
    required this.institutionController,
    required this.gradeController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Degree Field *
          TextFormField(
            controller: degreeController,
            decoration: InputDecoration(
              labelText: 'Degree *',
              hintText: 'e.g. Bachelor of Technology',
              prefixIcon: const Icon(Icons.school_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
              ),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Degree is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Field of Study Field *
          TextFormField(
            controller: fieldOfStudyController,
            decoration: InputDecoration(
              labelText: 'Field of Study *',
              hintText: 'e.g. Computer Science & Engineering',
              prefixIcon: const Icon(Icons.auto_stories_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
              ),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Field of study is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Institution Field *
          TextFormField(
            controller: institutionController,
            decoration: InputDecoration(
              labelText: 'Institution Name *',
              hintText: 'e.g. Indian Institute of Technology',
              prefixIcon: const Icon(Icons.account_balance_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
              ),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Institution name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Grade / CGPA Field
          TextFormField(
            controller: gradeController,
            decoration: InputDecoration(
              labelText: 'Grade / CGPA',
              hintText: 'e.g. 8.6 CGPA or 92%',
              prefixIcon: const Icon(Icons.grade_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusTextField),
              ),
            ),
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}
