import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const parser = ResumeParserImpl();

  group('ResumeParserImpl Unit Tests', () {
    test('Test 1 — Text Parsing extracts Personal Details & Sections without fabrication', () async {
      const sampleResumeText = '''
Alex Rivera
Senior Software Engineer
alex.rivera@example.com
(555) 019-2834
linkedin.com/in/alexrivera
github.com/alexrivera

SUMMARY
Results-driven Senior Software Engineer with 6+ years of experience building high-performance mobile and web applications using Flutter, Dart, and Cloud architectures.

EXPERIENCE
Senior Mobile Engineer
TechCorp Systems
Developed cross-platform applications serving 500k+ active users with 99.9% crash-free rate.

EDUCATION
Bachelor of Science in Computer Science
State University of Technology

SKILLS
Flutter, Dart, Mobile Architecture, Clean Architecture, REST APIs

PROJECTS
Vitafolio App
A premium AI-powered resume builder built with Flutter & Clean Architecture.

CERTIFICATIONS
Google Certified Associate Android Developer

LANGUAGES
English
Spanish
''';

      final resume = await parser.parseText(sampleResumeText);

      expect(resume.personalDetails?.fullName, equals('Alex Rivera'));
      expect(resume.personalDetails?.jobTitle, equals('Senior Software Engineer'));
      expect(resume.personalDetails?.email, equals('alex.rivera@example.com'));
      expect(resume.personalDetails?.phoneNumber, equals('(555) 019-2834'));
      expect(resume.summary, isNotNull);
      expect(resume.summary?.summaryText, isNotEmpty);
      expect(resume.experiences.length, greaterThanOrEqualTo(1));
      expect(resume.educations.length, greaterThanOrEqualTo(1));
      expect(resume.skills.length, greaterThanOrEqualTo(3));
      expect(resume.projects.length, greaterThanOrEqualTo(1));
      expect(resume.certifications.length, greaterThanOrEqualTo(1));
      expect(resume.languages.length, greaterThanOrEqualTo(1));
    });

    test('Test 2 — Empty string parsing throws descriptive Exception', () async {
      expect(
        () async => await parser.parseText('   '),
        throwsA(isA<Exception>()),
      );
    });

    test('Test 3 — File path with unsupported extension throws Exception', () async {
      expect(
        () async => await parser.parseFile('test.exe'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
