import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'template_renderer.dart';
import '../../preview/widgets/resume_header.dart';
import '../../preview/widgets/education_block.dart';
import '../../preview/widgets/experience_block.dart';
import '../../preview/widgets/skills_block.dart';
import '../../preview/widgets/projects_block.dart';
import '../../preview/widgets/certification_block.dart';
import '../../preview/widgets/language_block.dart';

class AtsTemplateRenderer implements TemplateRenderer {
  const AtsTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final educationList = resumeData.education
        .where((e) => e.school?.isNotEmpty ?? false)
        .toList();
    final experienceList = resumeData.experience
        .where((e) => e.company?.isNotEmpty ?? false)
        .toList();
    final projectsList = resumeData.projects
        .where((p) => p.projectName?.isNotEmpty ?? false)
        .toList();
    final certificationsList = resumeData.certifications
        .where((c) => c.certificateName?.isNotEmpty ?? false)
        .toList();
    final languagesList = resumeData.languages
        .where((l) => l.language?.isNotEmpty ?? false)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResumeHeader(personalInfo: resumeData.personalInfo),
        const SizedBox(height: 12),
        const Divider(color: Colors.black, thickness: 1),
        if (resumeData.summary.isNotEmpty) ...[
          Text(
            'SUMMARY',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            resumeData.summary,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 12),
        ],
        if (experienceList.isNotEmpty) ...[
          Text(
            'EXPERIENCE',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            children: experienceList
                .map((item) => ExperienceBlock(item: item))
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (educationList.isNotEmpty) ...[
          Text(
            'EDUCATION',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            children: educationList
                .map((item) => EducationBlock(item: item))
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (resumeData.skills.isNotEmpty) ...[
          Text(
            'SKILLS',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          SkillsBlock(skills: resumeData.skills),
          const SizedBox(height: 12),
        ],
        if (projectsList.isNotEmpty) ...[
          Text(
            'PROJECTS',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            children: projectsList
                .map((item) => ProjectsBlock(item: item))
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (certificationsList.isNotEmpty) ...[
          Text(
            'CERTIFICATIONS',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            children: certificationsList
                .map((item) => CertificationBlock(item: item))
                .toList(),
          ),
          const SizedBox(height: 12),
        ],
        if (languagesList.isNotEmpty) ...[
          Text(
            'LANGUAGES',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            children: languagesList
                .map((item) => LanguageBlock(item: item))
                .toList(),
          ),
        ],
      ],
    );
  }
}
