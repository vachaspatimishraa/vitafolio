import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'template_renderer.dart';
import '../../preview/widgets/resume_header.dart';
import '../../preview/widgets/resume_section.dart';
import '../../preview/widgets/education_block.dart';
import '../../preview/widgets/experience_block.dart';
import '../../preview/widgets/skills_block.dart';
import '../../preview/widgets/projects_block.dart';
import '../../preview/widgets/certification_block.dart';
import '../../preview/widgets/language_block.dart';

class CreativeTemplateRenderer implements TemplateRenderer {
  const CreativeTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.secondary;

    final educationList = resumeData.education.where((e) => e.title.isNotEmpty).toList();
    final experienceList = resumeData.experience.where((e) => e.title.isNotEmpty).toList();
    final projectsList = resumeData.projects.where((e) => e.title.isNotEmpty).toList();
    final certificationsList = resumeData.certifications.where((e) => e.title.isNotEmpty).toList();
    final languagesList = resumeData.languages.where((e) => e.title.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ResumeHeader(personalInfo: resumeData.personalInfo),
            ),
            Container(
              width: 4,
              height: 64,
              color: accentColor,
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (resumeData.summary.isNotEmpty)
          ResumeSection(
            title: 'About Me',
            child: Text(resumeData.summary, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
          ),
        if (experienceList.isNotEmpty)
          ResumeSection(
            title: 'My Experience',
            child: Column(
              children: experienceList.map((item) => ExperienceBlock(item: item)).toList(),
            ),
          ),
        if (educationList.isNotEmpty)
          ResumeSection(
            title: 'Education Journey',
            child: Column(
              children: educationList.map((item) => EducationBlock(item: item)).toList(),
            ),
          ),
        if (resumeData.skills.isNotEmpty)
          ResumeSection(
            title: 'Skills & Tools',
            child: SkillsBlock(skills: resumeData.skills),
          ),
        if (projectsList.isNotEmpty)
          ResumeSection(
            title: 'Key Projects',
            child: Column(
              children: projectsList.map((item) => ProjectsBlock(item: item)).toList(),
            ),
          ),
        if (certificationsList.isNotEmpty)
          ResumeSection(
            title: 'Achievements',
            child: Column(
              children: certificationsList.map((item) => CertificationBlock(item: item)).toList(),
            ),
          ),
        if (languagesList.isNotEmpty)
          ResumeSection(
            title: 'Languages Spoken',
            child: Column(
              children: languagesList.map((item) => LanguageBlock(item: item)).toList(),
            ),
          ),
      ],
    );
  }
}
