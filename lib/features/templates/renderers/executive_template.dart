import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class ExecutiveTemplateRenderer implements TemplateRenderer {
  const ExecutiveTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;

    const darkNavy = Color(0xFF13324C);
    const textDark = Color(0xFF222222);
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner (Dark Navy background with prominent uppercase name & sub-info)
          Container(
            width: double.infinity,
            color: darkNavy,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                Text(
                  (info.fullName?.trim().isNotEmpty == true)
                      ? info.fullName!.trim().toUpperCase()
                      : 'UNTITLED',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 4.0,
                    fontSize: 26,
                  ),
                ),
                if (info.jobTitle?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 6),
                  Text(
                    info.jobTitle!.trim().toUpperCase(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      letterSpacing: 2.0,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (contactItems.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    contactItems.join('   |   '),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(217),
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SUMMARY
                if (resumeData.summary.trim().isNotEmpty) ...[
                  _buildSectionHeader('SUMMARY', darkNavy, theme),
                  Text(
                    resumeData.summary.trim(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      height: 1.5,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // WORK EXPERIENCE
                if (experienceList.isNotEmpty) ...[
                  _buildSectionHeader('WORK EXPERIENCE', darkNavy, theme),
                  ...experienceList.map((exp) {
                    final title = exp.position?.trim() ?? '';
                    final company = exp.company?.trim() ?? '';
                    final dateStr =
                        '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}';

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
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textDark,
                              ),
                            ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              if (company.isNotEmpty)
                                Text(
                                  company,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    color: subtextColor,
                                  ),
                                ),
                              if (company.isNotEmpty && dateStr.isNotEmpty)
                                Text(
                                  '  |  ',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    color: subtextColor,
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
                            const SizedBox(height: 6),
                            ...descLines.map(
                              (line) => Padding(
                                padding: const EdgeInsets.only(left: 4.0, bottom: 3.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                                    Expanded(
                                      child: Text(
                                        line,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontSize: 12,
                                          height: 1.4,
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
                  const SizedBox(height: 12),
                ],

                // PROJECTS
                if (projectsList.isNotEmpty) ...[
                  _buildSectionHeader('PROJECTS', darkNavy, theme),
                  ...projectsList.map((proj) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
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
                            const SizedBox(height: 4),
                            Text(
                              proj.description!.trim(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                height: 1.4,
                                color: textDark,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                ],

                // Bottom Two-Column Section Grid
                LayoutBuilder(
                  builder: (context, constraints) {
                    final leftWidgets = <Widget>[
                      if (educationList.isNotEmpty) ...[
                        _buildSectionHeader('EDUCATION', darkNavy, theme),
                        ...educationList.map((edu) {
                          final degree = [
                            if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                            if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                          ].join(' in ');

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (degree.isNotEmpty)
                                  Text(
                                    degree,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: textDark,
                                    ),
                                  ),
                                if (edu.school?.trim().isNotEmpty == true) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    edu.school!.trim(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      color: subtextColor,
                                    ),
                                  ),
                                ],
                                if (edu.grade?.trim().isNotEmpty == true) ...[
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                                      Text(
                                        'Grade / CGPA: ${edu.grade!.trim()}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontSize: 11,
                                          color: textDark,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                      if (skillsList.isNotEmpty) ...[
                        _buildSectionHeader('SKILLS', darkNavy, theme),
                        Wrap(
                          spacing: 16,
                          runSpacing: 6,
                          children: skillsList.map((skill) {
                            return SizedBox(
                              width: constraints.maxWidth > 500 ? (constraints.maxWidth / 2 - 24) / 2 : 120,
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
                        ),
                      ],
                    ];

                    final rightWidgets = <Widget>[
                      if (certificationsList.isNotEmpty) ...[
                        _buildSectionHeader('CERTIFICATIONS', darkNavy, theme),
                        ...certificationsList.map((cert) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
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
                        const SizedBox(height: 12),
                      ],
                      if (languagesList.isNotEmpty) ...[
                        _buildSectionHeader('LANGUAGES', darkNavy, theme),
                        ...languagesList.map((lang) {
                          final name = lang.language?.trim() ?? '';
                          final prof = lang.proficiency.name;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
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
                    ];

                    if (leftWidgets.isEmpty && rightWidgets.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: leftWidgets,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: rightWidgets,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color darkNavy, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 13,
            color: darkNavy,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 1.2,
          color: darkNavy,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

