import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class ClassicTemplateRenderer implements TemplateRenderer {
  const ClassicTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;

    const creamBg = Color(0xFFF9F6F0);
    const dividerColor = Color(0xFFE2DAD0);
    const textDark = Color(0xFF1F1F1F);
    const subtextColor = Color(0xFF4A4A4A);

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
      color: creamBg,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Left (Name + Job Title), Right (Contact Info Stacked)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (info.fullName?.trim().isNotEmpty == true)
                          ? info.fullName!.trim().toUpperCase()
                          : 'KERWIN JEONG',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: textDark,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 3.5,
                        fontSize: 26,
                        fontFamily: 'Serif',
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
                  ],
                ),
              ),
              if (contactItems.isNotEmpty) ...[
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: contactItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        item,
                        textAlign: TextAlign.end,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: textDark,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),
          const Divider(color: dividerColor, thickness: 1.2),
          const SizedBox(height: 20),

          // PROFESSIONAL SUMMARY
          if (resumeData.summary.trim().isNotEmpty) ...[
            _buildSectionTitle('PROFESSIONAL SUMMARY', theme),
            Text(
              resumeData.summary.trim(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                height: 1.5,
                color: textDark,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: dividerColor, thickness: 1.2),
            const SizedBox(height: 20),
          ],

          // WORK EXPERIENCE
          if (experienceList.isNotEmpty) ...[
            _buildSectionTitle('WORK EXPERIENCE', theme),
            ...experienceList.map((exp) {
              final title = exp.position?.trim() ?? '';
              final dateStr =
                  '${_formatDate(exp.startDate)} - ${exp.isCurrentlyWorking == true ? "Present" : _formatDate(exp.endDate)}';
              final company = exp.company?.trim() ?? '';

              final titleDate = [
                if (title.isNotEmpty) title,
                if (dateStr.isNotEmpty) dateStr,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (titleDate.isNotEmpty)
                      Text(
                        titleDate,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: textDark,
                        ),
                      ),
                    if (company.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        company,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: subtextColor,
                        ),
                      ),
                    ],
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
            const Divider(color: dividerColor, thickness: 1.2),
            const SizedBox(height: 20),
          ],

          // Bottom Two Column Layout
          LayoutBuilder(
            builder: (context, constraints) {
              final leftWidgets = <Widget>[
                if (educationList.isNotEmpty) ...[
                  _buildSectionTitle('ACADEMIC HISTORY', theme),
                  ...educationList.map((edu) {
                    final school = edu.school?.trim() ?? '';
                    final dateStr =
                        '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}';
                    final schoolDate = [
                      if (school.isNotEmpty) school,
                      if (dateStr.isNotEmpty) dateStr,
                    ].join(' | ');

                    final degree = [
                      if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                      if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                    ].join(' in ');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (schoolDate.isNotEmpty)
                            Text(
                              schoolDate,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: textDark,
                              ),
                            ),
                          if (degree.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              degree,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: subtextColor,
                              ),
                            ),
                          ],
                          if (edu.grade?.trim().isNotEmpty == true) ...[
                            const SizedBox(height: 3),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                                Expanded(
                                  child: Text(
                                    'GPA: ${edu.grade!.trim()}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      color: textDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                if (skillsList.isNotEmpty) ...[
                  _buildSectionTitle('SKILLS', theme),
                  ...skillsList.map(
                    (skill) => Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
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
                    ),
                  ),
                ],
              ];

              final rightWidgets = <Widget>[
                if (certificationsList.isNotEmpty) ...[
                  _buildSectionTitle('CERTIFICATIONS', theme),
                  ...certificationsList.map((cert) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert.certificateName?.trim() ?? '',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textDark,
                            ),
                          ),
                          if (cert.organization?.trim().isNotEmpty == true) ...[
                            const SizedBox(height: 2),
                            Text(
                              cert.organization!.trim(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: subtextColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                if (projectsList.isNotEmpty) ...[
                  _buildSectionTitle('PROJECTS', theme),
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
                  const SizedBox(height: 16),
                ],

                if (languagesList.isNotEmpty) ...[
                  _buildSectionTitle('LANGUAGES', theme),
                  ...languagesList.map((lang) {
                    final name = lang.language?.trim() ?? '';
                    final prof = lang.proficiency.name;
                    return Padding(
                      padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
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
                  Container(
                    width: 1.2,
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    color: dividerColor,
                  ),
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
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 2.0,
          fontSize: 13,
          color: const Color(0xFF1F1F1F),
          fontFamily: 'Serif',
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}';
  }
}
