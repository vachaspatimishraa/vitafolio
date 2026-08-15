import 'package:flutter/material.dart';
import 'package:vitafolio/app/constants/app_spacing.dart';

/// Mock education data model for UI representation.
class MockEducation {
  final String id;
  final String degree;
  final String fieldOfStudy;
  final String institution;
  final String startYear;
  final String endYear;
  final String? grade;
  final String? description;

  const MockEducation({
    required this.id,
    required this.degree,
    required this.fieldOfStudy,
    required this.institution,
    required this.startYear,
    required this.endYear,
    this.grade,
    this.description,
  });
}

const List<MockEducation> kMockEducations = [
  MockEducation(
    id: 'edu_1',
    degree: 'Bachelor of Technology',
    fieldOfStudy: 'Computer Science & Engineering',
    institution: 'Indian Institute of Technology',
    startYear: '2020',
    endYear: '2024',
    grade: '8.6 CGPA',
    description:
        'Focused on Software Engineering, Data Structures, Algorithms, and Mobile Development.',
  ),
  MockEducation(
    id: 'edu_2',
    degree: 'Higher Secondary Education',
    fieldOfStudy: 'Science (PCM)',
    institution: 'Delhi Public School',
    startYear: '2018',
    endYear: '2020',
    grade: '94.2%',
  ),
];

/// Options popup menu for editing or deleting education items.
class EducationOptionsMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EducationOptionsMenu({
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
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
