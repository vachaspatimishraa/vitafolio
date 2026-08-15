import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class AcademicTemplateRenderer implements TemplateRenderer {
  const AcademicTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;

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

    final contactItems = <Map<String, String>>[
      if (info.phone?.trim().isNotEmpty == true) {'label': 'Phone', 'val': info.phone!.trim()},
      if (info.email?.trim().isNotEmpty == true) {'label': 'Email', 'val': info.email!.trim()},
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        {'label': 'Website', 'val': info.portfolioWebsite!.trim()},
      if (info.linkedIn?.trim().isNotEmpty == true) {'label': 'LinkedIn', 'val': info.linkedIn!.trim()},
      if (info.github?.trim().isNotEmpty == true) {'label': 'GitHub', 'val': info.github!.trim()},
    ];

    final nameParts = (info.fullName?.trim().isNotEmpty == true)
        ? info.fullName!.trim().split(' ')
        : ['HENRIETTA', 'MITCHELL'];
    final firstName = nameParts.first.toUpperCase();
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ').toUpperCase() : '';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column (~38% width)
          SizedBox(
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Large Stacked Header Name
                Text(
                  firstName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: textDark,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    fontSize: 26,
                    height: 1.1,
                  ),
                ),
                if (lastName.isNotEmpty)
                  Text(
                    lastName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: textDark,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 26,
                      height: 1.1,
                    ),
                  ),
                if (info.jobTitle?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 10),
                  Text(
                    info.jobTitle!.trim().toUpperCase(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: subtextColor,
                      letterSpacing: 1.5,
                      fontSize: 11,
                    ),
                  ),
                ],
                const SizedBox(height: 28),

                // PERSONAL PROFILE / SUMMARY
                if (resumeData.summary.trim().isNotEmpty) ...[
                  _buildLeftSectionHeader('PERSONAL PROFILE', theme),
                  Text(
                    resumeData.summary.trim(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      height: 1.4,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // CERTIFICATIONS
                if (certificationsList.isNotEmpty) ...[
                  _buildLeftSectionHeader('CERTIFICATIONS', theme),
                  ...certificationsList.map((cert) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.certificateName?.trim() ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textDark,
                            ),
                          ),
                          if (cert.organization?.trim().isNotEmpty == true)
                            Text(
                              cert.organization!.trim(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                color: subtextColor,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],

                // CONTACT INFORMATION
                if (contactItems.isNotEmpty) ...[
                  _buildLeftSectionHeader('CONTACT INFORMATION', theme),
                  ...contactItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${item['label']}:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: subtextColor,
                            ),
                          ),
                          Text(
                            item['val']!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              color: textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // LANGUAGES
                if (languagesList.isNotEmpty) ...[
                  _buildLeftSectionHeader('LANGUAGES', theme),
                  ...languagesList.map((lang) {
                    final name = lang.language?.trim() ?? '';
                    final prof = lang.proficiency.name;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        '$name ($prof)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          color: textDark,
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),

          const SizedBox(width: 32),

          // Right Column (Main content area)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EMPLOYMENT HISTORY
                if (experienceList.isNotEmpty) ...[
                  _buildRightSectionHeader('EMPLOYMENT HISTORY', theme),
                  ...experienceList.map((exp) {
                    final title = exp.position?.trim() ?? '';
                    final company = exp.company?.trim() ?? '';
                    final dateStr =
                        '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}';

                    final companyDate = [
                      if (company.isNotEmpty) company,
                      if (dateStr.isNotEmpty) '($dateStr)',
                    ].join(' ');

                    final descLines = <String>[];
                    if (exp.description?.trim().isNotEmpty == true) {
                      final rawLines = exp.description!.split('\n');
                      for (final line in rawLines) {
                        final trimmed = line.trim();
                        if (trimmed.isNotEmpty) {
                          if (trimmed.startsWith('-') || trimmed.startsWith('•')) {
                            descLines.add(trimmed.replaceAll(RegExp(r'^[\•\-]\s*'), ''));
                          } else {
                            descLines.add(trimmed);
                          }
                        }
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: textDark,
                              ),
                            ),
                          if (companyDate.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              companyDate,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 11,
                                color: subtextColor,
                              ),
                            ),
                          ],
                          if (descLines.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            ...descLines.map(
                              (line) => Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Text(
                                  '- $line',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 11,
                                    height: 1.35,
                                    color: textDark,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // PREVIOUS EDUCATION
                if (educationList.isNotEmpty) ...[
                  _buildRightSectionHeader('PREVIOUS EDUCATION', theme),
                  ...educationList.map((edu) {
                    final degreeDate = [
                      if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                      if (edu.fieldOfStudy?.trim().isNotEmpty == true) 'in ${edu.fieldOfStudy!.trim()}',
                      if (edu.endDate != null) ', ${_formatDate(edu.endDate)}',
                    ].join(' ');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (edu.school?.trim().isNotEmpty == true)
                            Text(
                              edu.school!.trim(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: textDark,
                              ),
                            ),
                          if (degreeDate.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              degreeDate,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 11,
                                color: subtextColor,
                              ),
                            ),
                          ],
                          if (edu.grade?.trim().isNotEmpty == true) ...[
                            const SizedBox(height: 2),
                            Text(
                              '- Grade / CGPA: ${edu.grade!.trim()}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 11,
                                color: textDark,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // PROJECTS
                if (projectsList.isNotEmpty) ...[
                  _buildRightSectionHeader('PROJECTS', theme),
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
                              '- ${proj.description!.trim()}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 11,
                                height: 1.35,
                                color: textDark,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // SKILLS AND ABILITIES
                if (skillsList.isNotEmpty) ...[
                  _buildRightSectionHeader('SKILLS AND ABILITIES', theme),
                  ...skillsList.map(
                    (skill) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        '- $skill',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          color: textDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSectionHeader(String title, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 12,
            color: const Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 3,
          color: const Color(0xFFDDDDDD),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildRightSectionHeader(String title, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 12,
            color: const Color(0xFF222222),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: 3,
          color: const Color(0xFFDDDDDD),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
