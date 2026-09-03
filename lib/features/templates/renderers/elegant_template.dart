import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class ElegantTemplateRenderer implements TemplateRenderer {
  const ElegantTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;

    const darkHeaderBg = Color(0xFF221E1F);
    const sidebarBg = Color(0xFFE4DDD6);
    const textDark = Color(0xFF1E1E1E);
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
          color: const Color(0xFF3A3435),
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: const Center(
          child: Icon(Icons.person, size: 72, color: Colors.white),
        ),
      );
    }

    final contactItems = <Map<String, dynamic>>[
      if (info.email?.trim().isNotEmpty == true)
        {'icon': Icons.email_outlined, 'val': info.email!.trim()},
      if (info.phone?.trim().isNotEmpty == true)
        {'icon': Icons.phone_outlined, 'val': info.phone!.trim()},
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        {'icon': Icons.language_outlined, 'val': info.portfolioWebsite!.trim()},
      if (info.linkedIn?.trim().isNotEmpty == true)
        {'icon': Icons.link_outlined, 'val': info.linkedIn!.trim()},
      if (info.github?.trim().isNotEmpty == true)
        {'icon': Icons.code_outlined, 'val': info.github!.trim()},
    ];

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Header Banner Stacked with Overlapping Circle Photo
          SizedBox(
            height: 160,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 130,
                  child: Container(
                    color: darkHeaderBg,
                    padding: const EdgeInsets.only(left: 240, right: 32),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (info.fullName?.trim().isNotEmpty == true)
                              ? info.fullName!.trim().toUpperCase()
                              : 'DONNA STROUPE',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.0,
                            fontSize: 26,
                          ),
                        ),
                        if (info.jobTitle?.trim().isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            info.jobTitle!.trim(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white.withAlpha(220),
                              fontSize: 14,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 40,
                  top: 10,
                  child: profilePhotoWidget,
                ),
              ],
            ),
          ),

          // Two-Column Body: Left Sidebar (Beige Background), Right Column (White)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Left Sidebar (~34% width)
                Container(
                  width: 220,
                  color: sidebarBg,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CONTACT INFO
                      if (contactItems.isNotEmpty) ...[
                        ...contactItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(item['icon'] as IconData, size: 16, color: textDark),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item['val'] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: textDark,
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
                        _buildSidebarSectionHeader('EDUCATION', theme),
                        ...educationList.map((edu) {
                          final degree = [
                            if (edu.degree?.trim().isNotEmpty == true) edu.degree!.trim(),
                            if (edu.fieldOfStudy?.trim().isNotEmpty == true) edu.fieldOfStudy!.trim(),
                          ].join(' in ');

                          final dateStr = DateRangeFormatter.formatEducation(
                            startDate: edu.startDate,
                            endDate: edu.endDate,
                            isCurrentlyStudying: edu.isCurrentlyStudying == true,
                            separator: ' - ',
                          );

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (degree.isNotEmpty)
                                  Text(
                                    degree,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: textDark,
                                    ),
                                  ),
                                if (edu.school?.trim().isNotEmpty == true)
                                  Text(
                                    edu.school!.trim(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: subtextColor,
                                    ),
                                  ),
                                if (dateStr.isNotEmpty)
                                  Text(
                                    dateStr,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      color: subtextColor,
                                    ),
                                  ),
                                if (edu.grade?.trim().isNotEmpty == true)
                                  Text(
                                    'GPA: ${edu.grade!.trim()}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      color: textDark,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                      ],

                      // SKILLS
                      if (skillsList.isNotEmpty) ...[
                        _buildSidebarSectionHeader('SKILLS', theme),
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
                                      fontSize: 11,
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

                      // LANGUAGE
                      if (languagesList.isNotEmpty) ...[
                        _buildSidebarSectionHeader('LANGUAGE', theme),
                        ...languagesList.map((lang) {
                          final name = lang.language?.trim() ?? '';
                          final prof = lang.proficiency.name;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              prof.isNotEmpty ? '$name ($prof)' : name,
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

                // Right Main Column (White Background)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ABOUT ME / SUMMARY
                        if (resumeData.summary.trim().isNotEmpty) ...[
                          _buildMainSectionHeader('About Me', theme),
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
                          _buildMainSectionHeader('WORK EXPERIENCE', theme),
                          ...experienceList.map((exp) {
                            final title = exp.position?.trim() ?? '';
                            final company = exp.company?.trim() ?? '';
                            final location = exp.location?.trim() ?? '';
                            final dateStr = DateRangeFormatter.formatExperience(
                              startDate: exp.startDate,
                              endDate: exp.endDate,
                              isCurrentRole: exp.isCurrentlyWorking == true,
                              separator: ' - ',
                            );

                            final companyLocation = [
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (dateStr.isNotEmpty)
                                    Text(
                                      dateStr,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 11,
                                        color: subtextColor,
                                      ),
                                    ),
                                  if (companyLocation.isNotEmpty)
                                    Text(
                                      companyLocation,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 12,
                                        color: subtextColor,
                                      ),
                                    ),
                                  if (title.isNotEmpty)
                                    Text(
                                      title,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: textDark,
                                      ),
                                    ),
                                  if (descLines.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    ...descLines.map(
                                      (line) => Padding(
                                        padding: const EdgeInsets.only(left: 4.0, bottom: 2.0),
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
                          _buildMainSectionHeader('PROJECTS', theme),
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
                                    const SizedBox(height: 3),
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

                        // CERTIFICATIONS
                        if (certificationsList.isNotEmpty) ...[
                          _buildMainSectionHeader('CERTIFICATIONS', theme),
                          ...certificationsList.map((cert) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
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
                ),
              ],
            ),
          ],
        ),
      );
  }

  Widget _buildSidebarSectionHeader(String title, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 13,
            color: const Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 1.2,
          color: const Color(0xFF1E1E1E),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildMainSectionHeader(String title, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 14,
            color: const Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 1.2,
          color: const Color(0xFF888888),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
