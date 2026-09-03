import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class CreativeTemplateRenderer implements TemplateRenderer {
  const CreativeTemplateRenderer();

  @override
  Widget render(WorkflowState resumeData, BuildContext context) {
    final theme = Theme.of(context);
    final info = resumeData.personalInfo;
    const slateBlue = Color(0xFF4A5D6E);
    const goldTan = Color(0xFFC69C6D);
    const lightBg = Color(0xFFF7F3EE);

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

    final nameParts = (info.fullName?.trim().isNotEmpty == true)
        ? info.fullName!.trim().split(' ')
        : ['UNTITLED', ''];
    final firstName = nameParts.first.toUpperCase();
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ').toUpperCase() : '';
    final jobTitle = info.jobTitle?.trim().isNotEmpty == true
        ? info.jobTitle!.trim().toUpperCase()
        : null;

    final photoPath = info.profileImagePath;
    final hasPhoto = photoPath != null && photoPath.trim().isNotEmpty && File(photoPath).existsSync();
    final Widget? profilePhotoWidget = hasPhoto
        ? Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: goldTan, width: 3),
              image: DecorationImage(
                image: FileImage(File(photoPath)),
                fit: BoxFit.cover,
              ),
            ),
          )
        : null;

    final contactItems = <String>[
      if (info.phone?.trim().isNotEmpty == true) info.phone!.trim(),
      if (info.email?.trim().isNotEmpty == true) info.email!.trim(),
      if (info.portfolioWebsite?.trim().isNotEmpty == true)
        info.portfolioWebsite!.trim(),
      if (info.linkedIn?.trim().isNotEmpty == true) info.linkedIn!.trim(),
      if (info.github?.trim().isNotEmpty == true) info.github!.trim(),
    ];

    return Column(
      children: [
        // Header Banner
        Container(
          width: double.infinity,
          color: slateBlue,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firstName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  if (lastName.isNotEmpty)
                    Text(
                      lastName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  if (jobTitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      jobTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: goldTan,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
              ?profilePhotoWidget,
            ],
          ),
        ),

        // Body Row
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CONTACT
                    if (contactItems.isNotEmpty) ...[
                      _buildSectionBanner('CONTACT', theme, slateBlue, Colors.white),
                      ...contactItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            item,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // SKILLS
                    if (resumeData.skills.isNotEmpty) ...[
                      _buildSectionBanner('SKILLS', theme, slateBlue, Colors.white),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          'PROFESSIONAL',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: slateBlue,
                          ),
                        ),
                      ),
                      ...resumeData.skills.map(
                        (skill) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBulletDot(slateBlue),
                              Expanded(
                                child: Text(
                                  skill,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: Colors.black87,
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
                      _buildSectionBanner('EDUCATION', theme, slateBlue, Colors.white),
                      ...educationList.map((edu) {
                        final school = edu.school?.trim() ?? '';
                        final degree = [
                          if (edu.degree?.trim().isNotEmpty == true)
                            edu.degree!.trim(),
                          if (edu.fieldOfStudy?.trim().isNotEmpty == true)
                            edu.fieldOfStudy!.trim(),
                        ].join(' in ');
                        final dateStr = DateRangeFormatter.formatEducation(
                          startDate: edu.startDate,
                          endDate: edu.endDate,
                          isCurrentlyStudying: edu.isCurrentlyStudying == true,
                          separator: ' - ',
                        );

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                margin: const EdgeInsets.only(top: 4, right: 6),
                                decoration: const BoxDecoration(
                                  color: slateBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (school.isNotEmpty)
                                      Text(
                                        school.toUpperCase(),
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    if (degree.isNotEmpty)
                                      Text(
                                        degree,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontSize: 11,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    Text(
                                      dateStr,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 10,
                                        color: Colors.grey[700],
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
                      _buildSectionBanner('LANGUAGES', theme, slateBlue, Colors.white),
                      ...languagesList.map(
                        (l) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBulletDot(slateBlue),
                              Expanded(
                                child: Text(
                                  '${l.language!.trim()} (${l.proficiency.name})',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontSize: 11,
                                    color: Colors.black87,
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

              const SizedBox(width: 20),

              // Right Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SUMMARY
                    if (resumeData.summary.trim().isNotEmpty) ...[
                      _buildSectionBanner('SUMMARY', theme, lightBg, slateBlue),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: goldTan, width: 2.5),
                          ),
                        ),
                        child: Text(
                          resumeData.summary.trim(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // WORKING EXPERIENCE
                    if (experienceList.isNotEmpty) ...[
                      _buildSectionBanner('WORKING EXPERIENCE', theme, lightBg, slateBlue),
                      ...experienceList.map((exp) {
                        final company = exp.company?.trim() ?? '';
                        final position = exp.position?.trim() ?? '';
                        final dateStr = DateRangeFormatter.formatExperience(
                          startDate: exp.startDate,
                          endDate: exp.endDate,
                          isCurrentRole: exp.isCurrentlyWorking == true,
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
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(top: 6, right: 8),
                                decoration: const BoxDecoration(
                                  color: slateBlue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      position.isNotEmpty
                                          ? position.toUpperCase()
                                          : company.toUpperCase(),
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      '$company   |   $dateStr',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 11,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    if (descLines.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      ...descLines.map(
                                        (line) => Padding(
                                          padding: const EdgeInsets.only(
                                            left: 2.0,
                                            bottom: 2.0,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildBulletDot(slateBlue),
                                              Expanded(
                                                child: Text(
                                                  line,
                                                  style: theme.textTheme.bodyMedium
                                                      ?.copyWith(
                                                        fontSize: 12,
                                                        color: Colors.black87,
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
                    ],

                    // PROJECTS
                    if (projectsList.isNotEmpty) ...[
                      _buildSectionBanner('PROJECTS', theme, lightBg, slateBlue),
                      ...projectsList.map(
                        (proj) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    proj.projectName?.trim() ?? '',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: slateBlue,
                                    ),
                                  ),
                                  if (proj.technologies?.trim().isNotEmpty == true)
                                    Text(
                                      proj.technologies!.trim(),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                              if (proj.description?.trim().isNotEmpty == true) ...[
                                const SizedBox(height: 2),
                                Text(
                                  proj.description!.trim(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // CERTIFICATIONS
                    if (certificationsList.isNotEmpty) ...[
                      _buildSectionBanner('CERTIFICATIONS', theme, lightBg, slateBlue),
                      ...certificationsList.map(
                        (cert) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cert.certificateName?.trim() ?? '',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                cert.organization?.trim() ?? '',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
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
        ),
      ],
    );
  }

  Widget _buildSectionBanner(
    String title,
    ThemeData theme,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: textColor,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildBulletDot(Color color) {
    return Container(
      width: 4.0,
      height: 4.0,
      margin: const EdgeInsets.only(top: 6.0, right: 8.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
