import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class ModernTemplateRenderer implements TemplateRenderer {
  const ModernTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;
    const deepOceanColor = Color(0xFF1B365D);
    const textDark = Color(0xFF222222);
    const textLight = Colors.white;
    const lineGrey = Color(0xFFE0E0E0);

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
    final skillsList = resumeData.skills;

    // Profile Photo Avatar
    Widget profilePhotoWidget;
    final photoPath = info.profileImagePath;
    if (photoPath != null && photoPath.trim().isNotEmpty && File(photoPath).existsSync()) {
      profilePhotoWidget = Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          image: DecorationImage(
            image: FileImage(File(photoPath)),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      profilePhotoWidget = Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF2C4D6F),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: const Center(
          child: Icon(Icons.person, size: 70, color: Colors.white),
        ),
      );
    }

    final contactItems = <Map<String, String>>[
      if (info.phone?.trim().isNotEmpty == true) {'icon': 'phone', 'val': info.phone!.trim()},
      if (info.email?.trim().isNotEmpty == true) {'icon': 'email', 'val': info.email!.trim()},
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        {'icon': 'website', 'val': info.portfolioWebsite!.trim()},
      if (info.linkedIn?.trim().isNotEmpty == true) {'icon': 'linkedin', 'val': info.linkedIn!.trim()},
      if (info.github?.trim().isNotEmpty == true) {'icon': 'github', 'val': info.github!.trim()},
    ];

    final nameParts = (info.fullName?.trim().isNotEmpty == true)
        ? info.fullName!.trim().split(' ')
        : ['RICHARD', 'SANCHEZ'];
    final firstName = nameParts.first.toUpperCase();
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ').toUpperCase() : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Deep Ocean Color) ~35% width
        Container(
          width: 210,
          color: deepOceanColor,
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: profilePhotoWidget),
              const SizedBox(height: 24),

              // CONTACT
              if (contactItems.isNotEmpty) ...[
                _buildSidebarTitle('CONTACT', theme),
                ...contactItems.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.circle, size: 4, color: textLight),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            c['val']!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textLight,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // EDUCATION
              if (educationList.isNotEmpty) ...[
                _buildSidebarTitle('EDUCATION', theme),
                ...educationList.map((edu) {
                  final dateStr = DateRangeFormatter.formatEducation(
                    startDate: edu.startDate,
                    endDate: edu.endDate,
                    isCurrentlyStudying: edu.isCurrentlyStudying == true,
                    ongoingLabel: 'PURSUING',
                    separator: ' - ',
                  );
                  final school = edu.school?.trim() ?? '';
                  final degree = [
                    if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                    if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                  ].join(' in ');

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (school.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            school.toUpperCase(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                        if (degree.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 4, right: 6),
                                child: Icon(Icons.circle, size: 3, color: textLight),
                              ),
                              Expanded(
                                child: Text(
                                  degree,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: textLight,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (edu.grade?.trim().isNotEmpty == true) ...[
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 4, right: 6),
                                child: Icon(Icons.circle, size: 3, color: textLight),
                              ),
                              Expanded(
                                child: Text(
                                  'GPA: ${edu.grade!.trim()}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: textLight,
                                    fontSize: 10.5,
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
                const SizedBox(height: 20),
              ],

              // SKILLS
              if (skillsList.isNotEmpty) ...[
                _buildSidebarTitle('SKILLS', theme),
                ...skillsList.map(
                  (skill) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Icon(Icons.circle, size: 3, color: textLight),
                        ),
                        Expanded(
                          child: Text(
                            skill,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textLight,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // LANGUAGES
              if (languagesList.isNotEmpty) ...[
                _buildSidebarTitle('LANGUAGES', theme),
                ...languagesList.map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Icon(Icons.circle, size: 3, color: textLight),
                        ),
                        Expanded(
                          child: Text(
                            '${l.language!.trim()} (${l.proficiency.name})',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textLight,
                              fontSize: 11,
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

        // Right Column (White) ~65% width
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name & Position Header
                Row(
                  children: [
                    Text(
                      '$firstName ',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        fontSize: 26,
                        letterSpacing: 1.5,
                      ),
                    ),
                    if (lastName.isNotEmpty)
                      Text(
                        lastName,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: deepOceanColor,
                          fontSize: 26,
                          letterSpacing: 1.5,
                        ),
                      ),
                  ],
                ),
                if (info.jobTitle?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    info.jobTitle!.trim().toUpperCase(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[700],
                      fontSize: 13,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(height: 1.5, color: deepOceanColor),
                ],

                const SizedBox(height: 20),

                // PROFILE / SUMMARY
                if (resumeData.summary.trim().isNotEmpty) ...[
                  _buildMainTitle('PROFILE', theme, textDark, lineGrey),
                  Text(
                    resumeData.summary.trim(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 11.5,
                      height: 1.4,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                // WORK EXPERIENCE
                if (experienceList.isNotEmpty) ...[
                  _buildMainTitle('WORK EXPERIENCE', theme, textDark, lineGrey),
                  ...experienceList.map((exp) {
                    final company = exp.company?.trim() ?? '';
                    final position = exp.position?.trim() ?? '';
                    final dateStr = DateRangeFormatter.formatExperience(
                      startDate: exp.startDate,
                      endDate: exp.endDate,
                      isCurrentRole: exp.isCurrentlyWorking == true,
                      ongoingLabel: 'PRESENT',
                      separator: ' - ',
                    );

                    final descLines = <String>[];
                    if (exp.description?.trim().isNotEmpty == true) {
                      final rawLines = exp.description!.split('\n');
                      for (final line in rawLines) {
                        final trimmed = line.trim();
                        if (trimmed.isNotEmpty) {
                          if (trimmed.startsWith('•') || trimmed.startsWith('-')) {
                            descLines.add(
                              trimmed.replaceAll(RegExp(r'^[\•\-]\s*'), ''),
                            );
                          } else {
                            descLines.add(trimmed);
                          }
                        }
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 5, right: 10),
                            decoration: const BoxDecoration(
                              color: deepOceanColor,
                              shape: BoxShape.circle,
                            ),
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
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: textDark,
                                        ),
                                      ),
                                    if (dateStr.isNotEmpty)
                                      Text(
                                        dateStr,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                  ],
                                ),
                                if (position.isNotEmpty)
                                  Text(
                                    position,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                if (descLines.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  ...descLines.map(
                                    (line) => Padding(
                                      padding: const EdgeInsets.only(left: 2.0, bottom: 2.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(top: 5, right: 6),
                                            child: Icon(Icons.circle, size: 3, color: textDark),
                                          ),
                                          Expanded(
                                            child: Text(
                                              line,
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
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],

                // PROJECTS
                if (projectsList.isNotEmpty) ...[
                  _buildMainTitle('PROJECTS', theme, textDark, lineGrey),
                  ...projectsList.map(
                    (proj) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  proj.projectName?.trim() ?? '',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: textDark,
                                  ),
                                ),
                              ),
                              if (proj.technologies?.trim().isNotEmpty == true)
                                Flexible(
                                  child: Text(
                                    proj.technologies!.trim(),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          if (proj.description?.trim().isNotEmpty == true) ...[
                            const SizedBox(height: 2),
                            Text(
                              proj.description!.trim(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 11.5,
                                color: textDark,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // CERTIFICATIONS
                if (certificationsList.isNotEmpty) ...[
                  _buildMainTitle('CERTIFICATIONS', theme, textDark, lineGrey),
                  ...certificationsList.map((cert) {
                    final certOrgDate = [
                      if (cert.organization?.trim().isNotEmpty == true) cert.organization!.trim(),
                      if (cert.issueDate != null) _formatDate(cert.issueDate),
                    ].join(' | ');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cert.certificateName?.trim() ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: textDark,
                            ),
                          ),
                          if (certOrgDate.isNotEmpty)
                            Text(
                              certOrgDate,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 11,
                                color: Colors.grey[700],
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(color: Colors.white70, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildMainTitle(String title, ThemeData theme, Color textDark, Color lineGrey) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: textDark,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Divider(color: lineGrey, thickness: 1),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}';
  }
}
