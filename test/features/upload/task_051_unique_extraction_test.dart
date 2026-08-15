import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const parser = ResumeParserImpl();

  group('TASK 051 Unique Values Extraction Tests', () {
    test('Test 1 — Extracts unique resume text without fallback to sample data', () async {
      const uniqueText = '''
VITAFOLIO_TEST_PERSON_987
Flutter Engineer UNIQUE ROLE 123
vitafolio.unique.987@example.com
+91 9876543210
linkedin.com/in/vitafoliounique
github.com/vitafoliounique

SUMMARY
Experienced engineer leading cross-platform development with UNIQUE SUMMARY CONTENT 999.

EXPERIENCE
Lead Developer
UNIQUE COMPANY ALPHA
Built high scale mobile applications.

EDUCATION
Bachelor of Engineering
UNIQUE UNIVERSITY DELTA

SKILLS
UNIQUE_SKILL_XYZ, Flutter, Riverpod

PROJECTS
UNIQUE PROJECT OMEGA
Built premium cross-platform resume builder.

CERTIFICATIONS
UNIQUE CERTIFICATION 777

LANGUAGES
UNIQUE_LANGUAGE_AAA
''';

      final resume = await parser.parseText(uniqueText);

      expect(resume.personalDetails?.fullName, equals('VITAFOLIO_TEST_PERSON_987'));
      expect(resume.personalDetails?.jobTitle, equals('Flutter Engineer UNIQUE ROLE 123'));
      expect(resume.personalDetails?.email, equals('vitafolio.unique.987@example.com'));
      expect(resume.personalDetails?.phoneNumber, equals('+91 9876543210'));
      expect(resume.summary?.summaryText, contains('UNIQUE SUMMARY CONTENT 999'));
      expect(resume.experiences.first.company, equals('UNIQUE COMPANY ALPHA'));
      expect(resume.educations.first.degree, contains('Bachelor of Engineering'));
      expect(resume.skills.map((s) => s.name), contains('UNIQUE_SKILL_XYZ'));
      expect(resume.projects.first.name, equals('UNIQUE PROJECT OMEGA'));
      expect(resume.certifications.first.name, equals('UNIQUE CERTIFICATION 777'));
      expect(resume.languages.first.name, equals('UNIQUE_LANGUAGE_AAA'));
    });
  });
}
