import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class AtsTemplateRenderer implements TemplateRenderer {
  const AtsTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;

    const textDark = Color(0xFF111111);
    const subtextColor = Color(0xFF444444);
    const lineGrey = Color(0xFFCCCCCC);

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

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Centered Uppercase Name, Subtitle, Contact Info (Icons + text)
          _buildHeader(info, theme, textDark, subtextColor),

          const SizedBox(height: 16),

          // SUMMARY
          if (resumeData.summary.trim().isNotEmpty) ...[
            _buildSectionTitle('Summary', theme, textDark, lineGrey),
            Text(
              resumeData.summary.trim(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 11.5,
                height: 1.45,
                color: textDark,
              ),
            ),
            const SizedBox(height: 18),
          ],

          // TECHNICAL SKILLS
          if (skillsList.isNotEmpty) ...[
            _buildSectionTitle('Technical Skills', theme, textDark, lineGrey),
            ...skillsList.map(
              (skill) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  skill,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11.5,
                    color: textDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],

          // PROJECTS
          if (projectsList.isNotEmpty) ...[
            _buildSectionTitle('Projects', theme, textDark, lineGrey),
            ...projectsList.map((proj) {
              final title = proj.projectName?.trim() ?? '';
              final tech = proj.technologies?.trim() ?? '';
              final titleTech = [
                if (title.isNotEmpty) title,
                if (tech.isNotEmpty) tech,
              ].join(' — ');

              final descLines = <String>[];
              if (proj.description?.trim().isNotEmpty == true) {
                final rawLines = proj.description!.split('\n');
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
                    if (titleTech.isNotEmpty)
                      Text(
                        titleTech,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                          color: textDark,
                        ),
                      ),
                    if (descLines.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      ...descLines.map(
                        (line) => Padding(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('- ', style: TextStyle(fontSize: 11.5, color: textDark)),
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
              );
            }),
            const SizedBox(height: 16),
          ],

          // WORK EXPERIENCE
          if (experienceList.isNotEmpty) ...[
            _buildSectionTitle('Experience', theme, textDark, lineGrey),
            ...experienceList.map((exp) {
              final title = exp.position?.trim() ?? '';
              final company = exp.company?.trim() ?? '';
              final titleCompany = [
                if (title.isNotEmpty) title,
                if (company.isNotEmpty) company,
              ].join(' — ');

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (titleCompany.isNotEmpty)
                          Expanded(
                            child: Text(
                              titleCompany,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                                color: textDark,
                              ),
                            ),
                          ),
                        if (dateStr.isNotEmpty)
                          Text(
                            dateStr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: textDark,
                            ),
                          ),
                      ],
                    ),
                    if (exp.location?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      Text(
                        exp.location!.trim(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                          color: subtextColor,
                        ),
                      ),
                    ],
                    if (descLines.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      ...descLines.map(
                        (line) => Padding(
                          padding: const EdgeInsets.only(left: 12.0, bottom: 2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('- ', style: TextStyle(fontSize: 11.5, color: textDark)),
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
              );
            }),
            const SizedBox(height: 16),
          ],

          // EDUCATION
          if (educationList.isNotEmpty) ...[
            _buildSectionTitle('Education', theme, textDark, lineGrey),
            ...educationList.map((edu) {
              final degree = [
                if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
              ].join(' in ');

              final school = edu.school?.trim() ?? '';
              final dateStr =
                  '${_formatDate(edu.startDate)} - ${edu.isCurrentlyStudying == true ? "Present" : _formatDate(edu.endDate)}';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (degree.isNotEmpty)
                          Text(
                            degree,
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
                              fontSize: 11,
                              color: textDark,
                            ),
                          ),
                      ],
                    ),
                    if (school.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        school,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                          fontSize: 11.5,
                          color: subtextColor,
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
          ],

          // CERTIFICATIONS
          if (certificationsList.isNotEmpty) ...[
            _buildSectionTitle('Certifications & Achievements', theme, textDark, lineGrey),
            ...certificationsList.map((cert) {
              final name = cert.certificateName?.trim() ?? '';
              final org = cert.organization?.trim() ?? '';
              final nameOrg = [
                if (name.isNotEmpty) name,
                if (org.isNotEmpty) org,
              ].join(' — ');

              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0, left: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                    Expanded(
                      child: Text(
                        nameOrg,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 11.5,
                          color: textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],

          // LANGUAGES
          if (languagesList.isNotEmpty) ...[
            _buildSectionTitle('Languages', theme, textDark, lineGrey),
            ...languagesList.map((lang) {
              final name = lang.language?.trim() ?? '';
              final prof = lang.proficiency.name;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0, left: 12.0),
                child: Row(
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                    Text(
                      name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 11.5,
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

  Widget _buildHeader(dynamic info, ThemeData theme, Color textDark, Color subtextColor) {
    final contactItems = <Map<String, dynamic>>[
      if (info.phone?.trim().isNotEmpty == true)
        {'icon': Icons.phone_outlined, 'val': info.phone!.trim()},
      if (info.email?.trim().isNotEmpty == true)
        {'icon': Icons.email_outlined, 'val': info.email!.trim()},
      if (info.linkedIn?.trim().isNotEmpty == true)
        {'icon': Icons.link_outlined, 'val': info.linkedIn!.trim()},
      if (info.github?.trim().isNotEmpty == true)
        {'icon': Icons.code_outlined, 'val': info.github!.trim()},
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        {'icon': Icons.language_outlined, 'val': info.portfolioWebsite!.trim()},
    ];

    return Center(
      child: Column(
        children: [
          Text(
            (info.fullName?.trim().isNotEmpty == true)
                ? info.fullName!.trim().toUpperCase()
                : 'VIKASH CHAURASIYA',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: textDark,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontSize: 26,
            ),
          ),
          if (info.jobTitle?.trim().isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              info.jobTitle!.trim(),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textDark,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
          if (contactItems.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 6,
              children: contactItems.map((item) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item['icon'] as IconData, size: 14, color: textDark),
                    const SizedBox(width: 4),
                    Text(
                      item['val'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textDark,
                        fontSize: 11,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme, Color textDark, Color lineGrey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: textDark,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          height: 1,
          color: lineGrey,
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
