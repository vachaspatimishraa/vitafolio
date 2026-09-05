import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Vikash Flutter PDF Native Extraction & Quality Tests', () {
    test('Real Vikash_Flutter .pdf native extraction succeeds with complete structured entities', () async {
      final file = File('test/fixtures/vikash_flutter.pdf');
      expect(file.existsSync(), isTrue);
      final bytes = await file.readAsBytes();

      final parser = ResumeParserImpl();
      final resume = await parser.parseBytes(bytes, ext: 'pdf');

      // Personal Details
      expect(resume.personalDetails?.fullName, equals('Vikash Chaurasiya'));
      expect(resume.personalDetails?.jobTitle, equals('Flutter Developer'));
      expect(resume.personalDetails?.email, equals('vikash_chaurasiya@yahoo.com'));
      expect(resume.personalDetails?.phoneNumber, equals('+91-8188801329'));
      expect(resume.personalDetails?.linkedinUrl, contains('linkedin.com/in/vikashchaurasiyafullstack'));
      expect(resume.personalDetails?.githubUrl, contains('github.com/provikash'));

      // Professional Summary
      expect(resume.summary?.summaryText, contains('Flutter Developer'));
      expect(resume.summary?.summaryText, contains('PrepMateAi'));

      // Skills
      expect(resume.skills.length, greaterThanOrEqualTo(10));
      expect(resume.skills.any((s) => s.name.contains('Flutter SDK')), isTrue);
      expect(resume.skills.any((s) => s.name.contains('Riverpod')), isTrue);
      expect(resume.skills.any((s) => s.name.contains('Dart')), isTrue);

      // Projects
      expect(resume.projects.length, equals(2));
      expect(resume.projects.any((p) => p.name.contains('PrepMateAi')), isTrue);
      expect(resume.projects.any((p) => p.name.contains('Vibely')), isTrue);

      // Education
      expect(resume.educations.length, greaterThanOrEqualTo(1));
      expect(resume.educations.first.degree, contains('Bachelor of Technology (B.Tech)'));
      expect(resume.educations.first.endYear, equals('2026'));

      // Certifications
      expect(resume.certifications.length, greaterThanOrEqualTo(2));
      expect(resume.certifications.any((c) => c.name.contains('AI Internship Certification')), isTrue);
    });
  });
}
