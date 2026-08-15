import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class CompactTemplateRenderer implements TemplateRenderer {
  const CompactTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;

    const textDark = Color(0xFF111111);
    const subtextColor = Color(0xFF555555);

    final educationList = resumeData.education
        .where((e) => (e.school?.isNotEmpty ?? false) || (e.degree?.isNotEmpty ?? false))
        .toList();
    final experienceList = resumeData.experience
        .where((e) => (e.company?.isNotEmpty ?? false) || (e.position?.isNotEmpty ?? false))
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
    final skillsList = resumeData.skills
        .where((s) => s.trim().isNotEmpty)
        .toList();

    final contactItems = <String>[
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        info.portfolioWebsite!.trim(),
      if (info.linkedIn?.trim().isNotEmpty == true) info.linkedIn!.trim(),
      if (info.github?.trim().isNotEmpty == true) info.github!.trim(),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner: Left (Name, Job Title, Contact links), Right (Vertical accent line)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (info.fullName?.trim().isNotEmpty == true)
                          ? info.fullName!.trim()
                          : 'Sebastian Bennett',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    if (info.jobTitle?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 6),
                      Text(
                        info.jobTitle!.trim().toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: subtextColor,
                          letterSpacing: 2.0,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    if (contactItems.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        contactItems.join(' | '),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 3,
                height: 80,
                color: Colors.black,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // SUMMARY
          if (resumeData.summary.trim().isNotEmpty) ...[
            _buildSectionBanner('SUMMARY', theme),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                resumeData.summary.trim(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  height: 1.4,
                  color: textDark,
                ),
              ),
            ),
          ],

          // WORK EXPERIENCE
          if (experienceList.isNotEmpty) ...[
            _buildSectionBanner('WORK EXPERIENCE', theme),
            const SizedBox(height: 10),
            ...experienceList.map((exp) {
              final title = exp.position?.trim() ?? '';
              final company = exp.company?.trim() ?? '';
              final titleCompany = [
                if (title.isNotEmpty) title,
                if (company.isNotEmpty) company,
              ].join(' | ');

              final dateStr =
                  '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "present" : _formatDate(exp.endDate)}';

              final descLines = <String>[];
              if (exp.description?.trim().isNotEmpty == true) {
                final rawLines = exp.description!.split('\n');
                for (final line in rawLines) {
                  final trimmed = line.trim();
                  if (trimmed.isNotEmpty) {
                    if (trimmed.startsWith('•') || trimmed.startsWith('-')) {
                      descLines.add(trimmed.replaceAll(RegExp(r'^[\•\-]\s*'), ''));
                    } else {
                      descLines.add(trimmed);
                    }
                  }
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            titleCompany,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textDark,
                            ),
                          ),
                        ),
                        if (dateStr.isNotEmpty)
                          Text(
                            dateStr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: subtextColor,
                            ),
                          ),
                      ],
                    ),
                    if (exp.location?.trim().isNotEmpty == true)
                      Text(
                        exp.location!.trim(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: subtextColor,
                        ),
                      ),
                    if (descLines.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      ...descLines.map(
                        (line) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                              Expanded(
                                child: Text(
                                  line,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    color: textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],

          // PROJECTS
          if (projectsList.isNotEmpty) ...[
            _buildSectionBanner('PROJECTS', theme),
            const SizedBox(height: 10),
            ...projectsList.map((proj) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proj.projectName?.trim() ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: textDark,
                      ),
                    ),
                    if (proj.technologies?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Technologies: ${proj.technologies!.trim()}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: subtextColor,
                        ),
                      ),
                    ],
                    if (proj.description?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 3),
                      Text(
                        proj.description!.trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: textDark,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],

          // SKILLS
          if (skillsList.isNotEmpty) ...[
            _buildSectionBanner('SKILLS', theme),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / 2 - 12;
                  return Wrap(
                    spacing: 24,
                    runSpacing: 6,
                    children: skillsList.map((skill) {
                      return SizedBox(
                        width: itemWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                            Expanded(
                              child: Text(
                                skill,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  color: textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],

          // EDUCATION
          if (educationList.isNotEmpty) ...[
            _buildSectionBanner('EDUCATION', theme),
            const SizedBox(height: 10),
            ...educationList.map((edu) {
              final degree = [
                if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
              ].join(' ');

              final school = edu.school?.trim() ?? '';
              final degreeSchool = [
                if (degree.isNotEmpty) degree,
                if (school.isNotEmpty) school,
              ].join(' | ');

              final dateStr =
                  '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "present" : _formatDate(edu.endDate)}';

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            degreeSchool,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textDark,
                            ),
                          ),
                        ),
                        if (dateStr.isNotEmpty)
                          Text(
                            dateStr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: subtextColor,
                            ),
                          ),
                      ],
                    ),
                    if (edu.grade?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '• GPA: ${edu.grade!.trim()}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            color: textDark,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],

          // CERTIFICATIONS
          if (certificationsList.isNotEmpty) ...[
            _buildSectionBanner('CERTIFICATIONS', theme),
            const SizedBox(height: 10),
            ...certificationsList.map((cert) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.certificateName?.trim() ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: textDark,
                            ),
                          ),
                          if (cert.organization?.trim().isNotEmpty == true)
                            Text(
                              cert.organization!.trim(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: subtextColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 10),
          ],

          // LANGUAGES
          if (languagesList.isNotEmpty) ...[
            _buildSectionBanner('LANGUAGES', theme),
            const SizedBox(height: 10),
            ...languagesList.map((lang) {
              final name = lang.language?.trim() ?? '';
              final prof = lang.proficiency.name;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 8.0),
                child: Row(
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                    Text(
                      name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textDark,
                      ),
                    ),
                    if (prof.isNotEmpty) ...[
                      Text(
                        ' ($prof)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: subtextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionBanner(String title, ThemeData theme) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontSize: 13,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
