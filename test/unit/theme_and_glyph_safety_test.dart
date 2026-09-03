import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/theme/theme_provider.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';

void main() {
  group('ThemeMode Default & Toggle Tests', () {
    test('ThemeModeNotifier defaults to ThemeMode.system', () {
      final notifier = ThemeModeNotifier();
      expect(notifier.state, ThemeMode.system);
    });

    test('ThemeModeNotifier toggles from system to opposite of current brightness', () {
      final notifier = ThemeModeNotifier();
      // Current system is dark -> toggles to light
      notifier.toggleTheme(Brightness.dark);
      expect(notifier.state, ThemeMode.light);

      // Toggles from light to dark
      notifier.toggleTheme(Brightness.light);
      expect(notifier.state, ThemeMode.dark);
    });

    test('ThemeModeNotifier toggles from system when dark to light', () {
      final notifier = ThemeModeNotifier();
      // Current system is light -> toggles to dark
      notifier.toggleTheme(Brightness.light);
      expect(notifier.state, ThemeMode.dark);
    });
  });

  group('PDF Glyph Safety & Sanitization Tests', () {
    test('PdfSectionHelper.sanitizeText replaces unsupported Unicode glyphs with ASCII', () {
      const input = 'VitaFolio – Resume — Senior “Engineer” ‘Lead’ • Dot';
      final output = PdfSectionHelper.sanitizeText(input);

      expect(output.contains('–'), isFalse, reason: 'Must not contain en-dash U+2013');
      expect(output.contains('—'), isFalse, reason: 'Must not contain em-dash U+2014');
      expect(output.contains('“'), isFalse, reason: 'Must not contain curly quotes');
      expect(output.contains('”'), isFalse, reason: 'Must not contain curly quotes');
      expect(output.contains('•'), isFalse, reason: 'Must not contain bullet char');
      expect(output, 'VitaFolio - Resume - Senior "Engineer" \'Lead\' - Dot');
    });

    test('PdfService.workflowStateFromDomain sanitizes resume data to prevent PDF missing glyphs', () {
      final resume = Resume(
        id: const ResumeId('1'),
        title: 'VitaFolio – Resume',
        selectedTemplateId: const TemplateId('ats'),
        personalDetails: const PersonalDetails(
          fullName: 'John – Doe',
          jobTitle: 'Software “Architect”',
          email: 'john@example.com',
          phoneNumber: '9876543210',
          address: '',
        ),
        experiences: [
          const Experience(
            id: '1',
            jobTitle: 'Lead Developer – Mobile',
            company: 'VitaFolio – Corp',
            location: 'Remote',
            startDate: '2020',
            endDate: '2024',
            description: 'Built features • Led team',
          ),
        ],
        skills: [
          const Skill(id: '1', name: 'Flutter – Dart'),
        ],
        educations: [],
        projects: [],
        certifications: [],
        languages: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final state = PdfService.workflowStateFromDomain(resume);

      expect(state.resumeName.contains('–'), isFalse);
      expect(state.personalInfo.fullName?.contains('–'), isFalse);
      expect(state.personalInfo.jobTitle?.contains('“'), isFalse);
      expect(state.experience.first.position?.contains('–'), isFalse);
      expect(state.experience.first.company?.contains('–'), isFalse);
      expect(state.experience.first.description?.contains('•'), isFalse);
      expect(state.skills.first.contains('–'), isFalse);
    });
  });

  group('Resume Extraction Additional Strengths & Parser Tests', () {
    test('ResumeParserImpl extracts skills under ADDITIONAL STRENGTHS header', () async {
      final parser = ResumeParserImpl();
      const resumeText = '''
JOHN DOE
john.doe@example.com
+1 555-123-4567

PROFESSIONAL SUMMARY
Experienced software engineer with full lifecycle expertise.

ADDITIONAL STRENGTHS
Flutter, Dart, Mobile Architecture, Clean Code

EXPERIENCE
Senior Engineer
Tech Corp
2020 - Present
Leading mobile development.
''';

      final resume = await parser.parseText(resumeText);
      expect(resume.skills.isNotEmpty, isTrue);
      final skillNames = resume.skills.map((s) => s.name).toList();
      expect(skillNames.contains('Flutter'), isTrue);
      expect(skillNames.contains('Dart'), isTrue);
      expect(skillNames.contains('Mobile Architecture'), isTrue);
      expect(skillNames.contains('Clean Code'), isTrue);
    });
  });
}
