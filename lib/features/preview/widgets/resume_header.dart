import 'package:flutter/material.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';
import 'package:vitafolio/features/preview/widgets/contact_information.dart';

class ResumeHeader extends StatelessWidget {
  final PersonalInformation personalInfo;

  const ResumeHeader({super.key, required this.personalInfo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final fullNameText = personalInfo.fullName?.isEmpty ?? true
        ? 'JANE DOE'
        : personalInfo.fullName!.toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          fullNameText,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        if (personalInfo.jobTitle?.isNotEmpty == true) ...[
          const SizedBox(height: 4),
          Text(
            personalInfo.jobTitle!.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ],
        const SizedBox(height: 8),
        ContactInformation(personalInfo: personalInfo),
      ],
    );
  }
}
