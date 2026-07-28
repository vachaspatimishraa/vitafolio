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

class ModernTemplateRenderer implements TemplateRenderer {
  const ModernTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final educationList = resumeData.education.where((e) => e.title.isNotEmpty).toList();
    final experienceList = resumeData.experience.where((e) => e.title.isNotEmpty).toList();
    final projectsList = resumeData.projects.where((e) => e.title.isNotEmpty).toList();
    final certificationsList = resumeData.certifications.where((e) => e.title.isNotEmpty).toList();
    final languagesList = resumeData.languages.where((e) => e.title.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ResumeHeader(personalInfo: resumeData.personalInfo),
        ),
        const SizedBox(height: 16),
        if (resumeData.summary.isNotEmpty)
          ResumeSection(
            title: 'Professional Summary',
            child: Text(resumeData.summary, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
          ),
        if (experienceList.isNotEmpty)
          ResumeSection(
            title: 'Experience',
            child: Column(
              children: experienceList.map((item) => ExperienceBlock(item: item)).toList(),
            ),
          ),
        if (educationList.isNotEmpty)
          ResumeSection(
            title: 'Education',
            child: Column(
              children: educationList.map((item) => EducationBlock(item: item)).toList(),
            ),
          ),
        if (resumeData.skills.isNotEmpty)
          ResumeSection(
            title: 'Skills',
            child: SkillsBlock(skills: resumeData.skills),
          ),
        if (projectsList.isNotEmpty)
          ResumeSection(
            title: 'Projects',
            child: Column(
              children: projectsList.map((item) => ProjectsBlock(item: item)).toList(),
            ),
          ),
        if (certificationsList.isNotEmpty)
          ResumeSection(
            title: 'Certifications',
            child: Column(
              children: certificationsList.map((item) => CertificationBlock(item: item)).toList(),
            ),
          ),
        if (languagesList.isNotEmpty)
          ResumeSection(
            title: 'Languages',
            child: Column(
              children: languagesList.map((item) => LanguageBlock(item: item)).toList(),
            ),
          ),
      ],
    );
  }
}
