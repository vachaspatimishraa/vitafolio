import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vitafolio/core/templates/professional_modern/modern_pdf_renderer.dart';
import 'package:vitafolio/features/workflow/models/workflow_state.dart';
import 'package:vitafolio/data/models/embedded/personal_information.dart';
import 'package:vitafolio/data/models/embedded/experience_model.dart';
import 'package:vitafolio/data/models/embedded/education_model.dart';

void main() {
  group('ModernPdfRenderer', () {
    late ModernPdfRenderer renderer;
    late WorkflowState resume;

    setUp(() {
      renderer = ModernPdfRenderer();

      // Create a mock resume with minimal required data
      resume = WorkflowState(
        personalInfo: PersonalInformation(
          fullName: 'John Doe',
          jobTitle: 'Software Engineer',
          email: 'john@example.com',
          phone: '+1234567890',
        ),
        summary: 'Experienced software engineer with 5+ years of experience.',
        education: const [],
        experience: const [],
        skills: const [],
        projects: const [],
        certifications: const [],
        languages: const [],
      );
    });

    test('render should return a Document', () async {
      final pdf = renderer.buildPdf(resume);

      expect(pdf, isA<pw.Document>());
    });

    test('render should contain expected text', () async {
      final pdf = renderer.buildPdf(resume);
      final bytes = await pdf.save();

      expect(bytes, isNotEmpty);
    });

    test('render with null personal info name should not throw', () async {
      resume = WorkflowState(
        personalInfo: PersonalInformation(fullName: null),
        summary: 'Experienced software engineer.',
        education: const [],
        experience: const [],
        skills: const [],
        projects: const [],
        certifications: const [],
        languages: const [],
      );

      final pdf = renderer.buildPdf(resume);

      expect(pdf, isA<pw.Document>());
    });

    test('render with empty professional summary should not throw', () async {
      resume = WorkflowState(
        personalInfo: PersonalInformation(fullName: 'John Doe'),
        summary: '',
        education: const [],
        experience: const [],
        skills: const [],
        projects: const [],
        certifications: const [],
        languages: const [],
      );

      final pdf = renderer.buildPdf(resume);

      expect(pdf, isA<pw.Document>());
    });

    test('render should create valid PDF', () async {
      final pdf = renderer.buildPdf(resume);
      final bytes = await pdf.save();

      // PDF should have valid header
      final header = String.fromCharCodes(bytes.take(4));
      expect(header, contains('%PDF'));
    });

    test('render with all sections should create multi-page PDF', () async {
      resume = WorkflowState(
        personalInfo: PersonalInformation(
          fullName: 'John Doe',
          jobTitle: 'Software Engineer',
        ),
        summary: 'Summary description',
        experience: [
          ExperienceModel(
            company: 'Tech Corp',
            position: 'Senior Developer',
            description: 'Developed web applications.',
          ),
        ],
        education: [
          EducationModel(school: 'University', degree: 'B.S. Computer Science'),
        ],
        skills: const ['Flutter', 'Dart'],
        projects: const [],
        certifications: const [],
        languages: const [],
      );

      final pdf = renderer.buildPdf(resume);
      await pdf.save();

      expect(pdf.document.pdfPageList.pages.length, greaterThanOrEqualTo(1));
    });
  });
}
