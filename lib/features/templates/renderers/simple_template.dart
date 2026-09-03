import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class SimpleTemplateRenderer implements TemplateRenderer {
  const SimpleTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;

    const peachCircleColor = Color(0xFFFFE3D3);
    const textDark = Color(0xFF1E1E1E);
    const subtextColor = Color(0xFF555555);
    const lineGrey = Color(0xFF888888);

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

    final contactItems = <Map<String, dynamic>>[
      if (info.phone?.trim().isNotEmpty == true)
        {'icon': Icons.phone_outlined, 'val': 'Telp: ${info.phone!.trim()}'},
      if (info.email?.trim().isNotEmpty == true)
        {'icon': Icons.email_outlined, 'val': 'Email: ${info.email!.trim()}'},
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        {'icon': Icons.language_outlined, 'val': info.portfolioWebsite!.trim()},
      if (info.linkedIn?.trim().isNotEmpty == true)
        {'icon': Icons.link_outlined, 'val': info.linkedIn!.trim()},
      if (info.github?.trim().isNotEmpty == true)
        {'icon': Icons.code_outlined, 'val': info.github!.trim()},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Stack: Soft Peach Accent Circle + Uppercase Full Name & Pill Job Title Box
          SizedBox(
            height: 140,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Soft Peach Decorative Circle on top-left
                Positioned(
                  top: -20,
                  left: -20,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: peachCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 24,
                  left: 60,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (info.fullName?.trim().isNotEmpty == true)
                            ? info.fullName!.trim().toUpperCase()
                            : 'CLAUDIA ALVES',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: textDark,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 4.0,
                          fontSize: 26,
                        ),
                      ),
                      if (info.jobTitle?.trim().isNotEmpty == true) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: textDark, width: 1.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            info.jobTitle!.trim().toUpperCase(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textDark,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2.0,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Body with Left Margin Accent Line
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Margin Vertical Line
              Container(
                width: 1.2,
                height: 650,
                margin: const EdgeInsets.only(right: 28),
                color: lineGrey,
              ),

              // Right Main Content Section Stack
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CONTACT
                    if (contactItems.isNotEmpty) ...[
                      _buildSectionTitle('C O N T A C T', theme),
                      ...contactItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: textDark, width: 1),
                                ),
                                child: Center(
                                  child: Icon(item['icon'] as IconData, size: 12, color: textDark),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item['val'] as String,
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
                      const SizedBox(height: 24),
                    ],

                    // SUMMARY
                    if (resumeData.summary.trim().isNotEmpty) ...[
                      _buildSectionTitle('S U M M A R Y', theme),
                      Text(
                        resumeData.summary.trim(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          height: 1.5,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // WORK EXPERIENCE
                    if (experienceList.isNotEmpty) ...[
                      _buildSectionTitle('E X P E R I E N C E :', theme),
                      ...experienceList.map((exp) {
                        final title = exp.position?.trim() ?? '';
                        final company = exp.company?.trim() ?? '';
                        final dateStr = DateRangeFormatter.formatExperience(
                          startDate: exp.startDate,
                          endDate: exp.endDate,
                          isCurrentRole: exp.isCurrentlyWorking == true,
                          separator: ' - ',
                        );

                        final companyDate = [
                          if (company.isNotEmpty) company,
                          if (dateStr.isNotEmpty) dateStr,
                        ].join(' – ');

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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (companyDate.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    companyDate,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      color: subtextColor,
                                    ),
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
                      const SizedBox(height: 16),
                    ],

                    // PROJECTS
                    if (projectsList.isNotEmpty) ...[
                      _buildSectionTitle('P R O J E C T S :', theme),
                      ...projectsList.map((proj) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                                  Expanded(
                                    child: Text(
                                      proj.projectName?.trim() ?? '',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: textDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (proj.technologies?.trim().isNotEmpty == true) ...[
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    'Technologies: ${proj.technologies!.trim()}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: subtextColor,
                                    ),
                                  ),
                                ),
                              ],
                              if (proj.description?.trim().isNotEmpty == true) ...[
                                const SizedBox(height: 3),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    proj.description!.trim(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      height: 1.4,
                                      color: textDark,
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

                    // SKILLS
                    if (skillsList.isNotEmpty) ...[
                      _buildSectionTitle('S K I L L S :', theme),
                      ...skillsList.map(
                        (skill) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
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
                      const SizedBox(height: 16),
                    ],

                    // EDUCATION
                    if (educationList.isNotEmpty) ...[
                      _buildSectionTitle('E D U C A T I O N :', theme),
                      ...educationList.map((edu) {
                        final degree = [
                          if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                          if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                        ].join(' in ');

                        final school = edu.school?.trim() ?? '';
                        final dateStr = DateRangeFormatter.formatEducation(
                          startDate: edu.startDate,
                          endDate: edu.endDate,
                          isCurrentlyStudying: edu.isCurrentlyStudying == true,
                          separator: ' - ',
                        );

                        final schoolDate = [
                          if (school.isNotEmpty) school,
                          if (dateStr.isNotEmpty) dateStr,
                        ].join(' – ');

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (degree.isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('• ', style: TextStyle(fontSize: 12, color: textDark)),
                                    Expanded(
                                      child: Text(
                                        degree,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: textDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (schoolDate.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    schoolDate,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      color: subtextColor,
                                    ),
                                  ),
                                ),
                              ],
                              if (edu.grade?.trim().isNotEmpty == true) ...[
                                const SizedBox(height: 2),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    'GPA: ${edu.grade!.trim()}',
                                    style: theme.textTheme.bodySmall?.copyWith(
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
                      const SizedBox(height: 16),
                    ],

                    // CERTIFICATIONS
                    if (certificationsList.isNotEmpty) ...[
                      _buildSectionTitle('C E R T I F I C A T I O N S :', theme),
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
                      const SizedBox(height: 16),
                    ],

                    // LANGUAGES
                    if (languagesList.isNotEmpty) ...[
                      _buildSectionTitle('L A N G U A G E S :', theme),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
          fontSize: 13,
          color: const Color(0xFF555555),
        ),
      ),
    );
  }
}
