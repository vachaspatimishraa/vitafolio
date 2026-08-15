import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class MinimalTemplateRenderer implements TemplateRenderer {
  const MinimalTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;

    const darkTitleColor = Color(0xFF1E2749);
    const textDark = Color(0xFF222222);
    const subtextColor = Color(0xFF555555);
    const dividerColor = Color(0xFFCCCCCC);

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
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        info.portfolioWebsite!.trim(),
      if (info.linkedIn?.trim().isNotEmpty == true) info.linkedIn!.trim(),
      if (info.github?.trim().isNotEmpty == true) info.github!.trim(),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      child: Column(
        children: [
          // Header: Centered Large Bold Title, Contact Info Links Below, Underline
          Center(
            child: Column(
              children: [
                Text(
                  (info.fullName?.trim().isNotEmpty == true)
                      ? info.fullName!.trim().toUpperCase()
                      : 'AARYA AGARWAL',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: darkTitleColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                    fontSize: 28,
                  ),
                ),
                if (contactItems.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    contactItems.join(' | '),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textDark,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: dividerColor, thickness: 1.0),
          const SizedBox(height: 20),

          // Two-Column Body with Vertical Divider
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (~60% width): SUMMARY & EXPERIENCE & PROJECTS
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SUMMARY
                    if (resumeData.summary.trim().isNotEmpty) ...[
                      _buildLeftSectionHeader('SUMMARY', theme),
                      Text(
                        resumeData.summary.trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 11.5,
                          height: 1.45,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: dividerColor, thickness: 1.0),
                      const SizedBox(height: 20),
                    ],

                    // EXPERIENCE
                    if (experienceList.isNotEmpty) ...[
                      _buildLeftSectionHeader('EXPERIENCE', theme),
                      ...experienceList.map((exp) {
                        final title = exp.position?.trim() ?? '';
                        final company = exp.company?.trim() ?? '';
                        final location = exp.location?.trim() ?? '';
                        final dateStr =
                            '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "PRESENT" : _formatDate(exp.endDate)}';

                        final companyLoc = [
                          if (company.isNotEmpty) company,
                          if (location.isNotEmpty) location,
                        ].join(' | ');

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
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timeline Bullet Indicator
                              Column(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    margin: const EdgeInsets.only(top: 5, right: 10),
                                    decoration: const BoxDecoration(
                                      color: textDark,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (company.isNotEmpty)
                                          Text(
                                            company,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.5,
                                              color: textDark,
                                            ),
                                          ),
                                        if (dateStr.isNotEmpty)
                                          Text(
                                            dateStr,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.5,
                                              color: textDark,
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (title.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        title,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontSize: 11.5,
                                          color: subtextColor,
                                        ),
                                      ),
                                    ],
                                    if (companyLoc.isNotEmpty && company.isEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        companyLoc,
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
                                          padding: const EdgeInsets.only(left: 2.0, bottom: 3.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('• ', style: TextStyle(fontSize: 11, color: textDark)),
                                              Expanded(
                                                child: Text(
                                                  line,
                                                  style: theme.textTheme.bodyMedium?.copyWith(
                                                    fontSize: 11.5,
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
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      const Divider(color: dividerColor, thickness: 1.0),
                      const SizedBox(height: 20),
                    ],

                      // PROJECTS
                      if (projectsList.isNotEmpty) ...[
                        _buildLeftSectionHeader('PROJECTS', theme),
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
                                    fontSize: 12.5,
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
                                      fontSize: 11.5,
                                      height: 1.4,
                                      color: textDark,
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
                ),

              // Vertical Column Divider
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: textDark,
              ),

              // Right Column (~40% width): SKILLS, EDUCATION, CERTIFICATIONS, LANGUAGE
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SKILLS
                    if (skillsList.isNotEmpty) ...[
                      _buildRightSectionHeader('SKILLS', theme),
                      ...skillsList.map(
                        (skill) => Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 11, color: textDark)),
                              Expanded(
                                child: Text(
                                  skill,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 11.5,
                                    color: textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: dividerColor, thickness: 1.0),
                      const SizedBox(height: 16),
                    ],

                    // EDUCATION
                    if (educationList.isNotEmpty) ...[
                      _buildRightSectionHeader('EDUCATION', theme),
                      ...educationList.map((edu) {
                        final dateStr =
                            '${_formatDate(edu.startDate)} - ${_formatDate(edu.endDate)}';
                        final degree = [
                          if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                          if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                        ].join(' ');

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (dateStr.isNotEmpty)
                                Text(
                                  dateStr,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.5,
                                    color: textDark,
                                  ),
                                ),
                              if (edu.school?.trim().isNotEmpty == true) ...[
                                const SizedBox(height: 2),
                                Text(
                                  edu.school!.trim(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.5,
                                    color: textDark,
                                  ),
                                ),
                              ],
                              if (degree.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  degree,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 11,
                                    height: 1.4,
                                    color: textDark,
                                  ),
                                ),
                              ],
                              if (edu.grade?.trim().isNotEmpty == true) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'GPA: ${edu.grade!.trim()}',
                                  style: theme.textTheme.bodySmall?.copyWith(
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
                      const Divider(color: dividerColor, thickness: 1.0),
                      const SizedBox(height: 16),
                    ],

                    // CERTIFICATIONS
                    if (certificationsList.isNotEmpty) ...[
                      _buildRightSectionHeader('CERTIFICATIONS', theme),
                      ...certificationsList.map((cert) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cert.certificateName?.trim() ?? '',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                  color: textDark,
                                ),
                              ),
                              if (cert.organization?.trim().isNotEmpty == true) ...[
                                const SizedBox(height: 2),
                                Text(
                                  cert.organization!.trim(),
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
                      const SizedBox(height: 16),
                      const Divider(color: dividerColor, thickness: 1.0),
                      const SizedBox(height: 16),
                    ],

                    // LANGUAGE
                    if (languagesList.isNotEmpty) ...[
                      _buildRightSectionHeader('LANGUAGE', theme),
                      ...languagesList.map((lang) {
                        final name = lang.language?.trim() ?? '';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 11.5,
                                  color: textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Rounded progress bar indicator
                              Container(
                                height: 6,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF222222),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontSize: 13,
          color: const Color(0xFF1E2749),
        ),
      ),
    );
  }

  Widget _buildRightSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          fontSize: 13,
          color: const Color(0xFF1E2749),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}';
  }
}
