import 'package:flutter/material.dart';
import '../../../core/templates/models/resume_template.dart' as core;
import '../../../data/models/embedded/education_model.dart';
import '../../../data/models/embedded/experience_model.dart';
import '../../../data/models/embedded/personal_information.dart';
import '../../workflow/models/workflow_state.dart';

final _sampleWorkflowState = WorkflowState(
  personalInfo: PersonalInformation(
    fullName: 'John Doe',
    jobTitle: 'Software Engineer',
    email: 'john@example.com',
    phone: '+1 234 567 890',
  ),
  summary: 'Experienced software engineer specializing in cross-platform mobile architecture, scalable apps, and UI/UX design.',
  experience: [
    ExperienceModel(
      company: 'Tech Solutions',
      position: 'Senior Developer',
      description: 'Built high performance Flutter and backend services.',
    ),
  ],
  education: [
    EducationModel(
      school: 'State University',
      degree: 'B.S. Computer Science',
    ),
  ],
  skills: const ['Flutter', 'Dart', 'Python', 'SQL', 'Git'],
  projects: const [],
  certifications: const [],
  languages: const [],
);

class TemplateThumbnail extends StatelessWidget {
  final core.ResumeTemplate template;
  final String heroTag;

  const TemplateThumbnail({
    super.key,
    required this.template,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: IgnorePointer(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: 380,
              height: 537,
              child: template.renderer.buildPreview(_sampleWorkflowState, context),
            ),
          ),
        ),
      ),
    );
  }
}
