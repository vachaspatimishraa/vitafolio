import 'package:flutter/material.dart';

/// Mock experience item data model.
class MockExperience {
  final String id;
  final String jobTitle;
  final String companyName;
  final String location;
  final String dateRange;
  final bool isCurrentlyWorking;
  final String? employmentType;
  final List<String> responsibilities;

  const MockExperience({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.dateRange,
    required this.isCurrentlyWorking,
    this.employmentType,
    required this.responsibilities,
  });
}

const List<MockExperience> kMockExperiences = [
  MockExperience(
    id: 'exp_1',
    jobTitle: 'Senior Flutter Developer',
    companyName: 'Google',
    location: 'Bengaluru, India',
    dateRange: 'Jan 2023 – Present',
    isCurrentlyWorking: true,
    employmentType: 'Full-time',
    responsibilities: [
      'Architected cross-platform mobile suite using Flutter & Riverpod.',
      'Reduced initial load latency by 35% through custom asset caching.',
    ],
  ),
  MockExperience(
    id: 'exp_2',
    jobTitle: 'Mobile Application Engineer',
    companyName: 'TechCorp Solutions',
    location: 'Remote',
    dateRange: 'Mar 2021 – Dec 2022',
    isCurrentlyWorking: false,
    employmentType: 'Full-time',
    responsibilities: [
      'Developed fintech dashboard supporting over 500k monthly active users.',
      'Implemented automated CI/CD deployment pipelines using Fastlane.',
    ],
  ),
];

/// Popup options menu widget for experience cards.
class ExperienceOptionsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExperienceOptionsMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          onEdit();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: 10),
              const Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: colorScheme.error),
              const SizedBox(width: 10),
              Text('Delete', style: TextStyle(color: colorScheme.error)),
            ],
          ),
        ),
      ],
    );
  }
}
