import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/docx/docx_export_service.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/features/education/presentation/viewmodels/education_viewmodel.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Education "Pursuing" vs Experience "Present" Terminology Tests', () {
    test('MockEducationItem.fromDomain creates "Pursuing" when isCurrentlyStudying is true', () {
      const edu = Education(
        id: 'edu-1',
        degree: 'B.Tech',
        fieldOfStudy: 'Computer Science',
        institution: 'MIT',
        location: 'Cambridge, MA',
        startYear: '2022',
        endYear: '',
        isCurrentlyStudying: true,
      );

      final item = MockEducationItem.fromDomain(edu);
      expect(item.dateRange, equals('2022 - Pursuing'));
    });

    test('MockEducationItem.fromDomain creates normal end year when isCurrentlyStudying is false', () {
      const edu = Education(
        id: 'edu-2',
        degree: 'B.Tech',
        fieldOfStudy: 'Computer Science',
        institution: 'MIT',
        location: 'Cambridge, MA',
        startYear: '2020',
        endYear: '2024',
        isCurrentlyStudying: false,
      );

      final item = MockEducationItem.fromDomain(edu);
      expect(item.dateRange, equals('2020 - 2024'));
    });

    test('MockEducationItem.toDomain parses "Pursuing" back to isCurrentlyStudying = true', () {
      const item = MockEducationItem(
        id: 'edu-1',
        degree: 'B.Tech',
        fieldOfStudy: 'Computer Science',
        institution: 'MIT',
        dateRange: '2022 - Pursuing',
        grade: '3.9 GPA',
        description: '',
      );

      final domain = item.toDomain();
      expect(domain.isCurrentlyStudying, isTrue);
      expect(domain.startYear, equals('2022'));
      expect(domain.endYear, isEmpty);
    });

    test('DocxExportService renders "Pursuing" for education and "Present" for experience', () {
      const docxService = DocxExportService();

      final resume = Resume(
        id: const ResumeId('test-1'),
        title: 'Software Engineer',
        selectedTemplateId: const TemplateId('modern'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        personalDetails: const PersonalDetails(
          fullName: 'Alex Montgomery',
          jobTitle: 'Software Engineer',
          email: 'alex@example.com',
          phoneNumber: '+1 555-0100',
          address: 'New York, NY',
        ),
        experiences: const [
          Experience(
            id: 'exp-1',
            jobTitle: 'Senior Developer',
            company: 'TechCorp',
            location: 'Remote',
            startDate: '2022',
            endDate: 'Present',
            isCurrentRole: true,
            description: 'Building mobile applications.',
          ),
        ],
        educations: const [
          Education(
            id: 'edu-1',
            degree: 'B.S.',
            fieldOfStudy: 'Computer Science',
            institution: 'Stanford',
            location: 'Stanford, CA',
            startYear: '2022',
            endYear: '',
            isCurrentlyStudying: true,
          ),
        ],
      );

      final bytes = docxService.generateDocx(resume);
      final archive = ZipDecoder().decodeBytes(bytes);
      final docXml = utf8.decode(archive.findFile('word/document.xml')!.content as List<int>);

      // Education must use Pursuing
      expect(docXml, contains('2022 - Pursuing'));
      // Experience must use Present
      expect(docXml, contains('2022 - Present'));
    });

    test('PdfService renders all templates with "Pursuing" for active education', () async {
      final pdfService = PdfService();

      final resume = Resume(
        id: const ResumeId('test-2'),
        title: 'Software Engineer',
        selectedTemplateId: const TemplateId('ats'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        personalDetails: const PersonalDetails(
          fullName: 'Alex Montgomery',
          jobTitle: 'Software Engineer',
          email: 'alex@example.com',
          phoneNumber: '+1 555-0100',
          address: 'New York, NY',
        ),
        experiences: const [
          Experience(
            id: 'exp-1',
            jobTitle: 'Senior Developer',
            company: 'TechCorp',
            location: 'Remote',
            startDate: '2022',
            endDate: 'Present',
            isCurrentRole: true,
            description: 'Building mobile applications.',
          ),
        ],
        educations: const [
          Education(
            id: 'edu-1',
            degree: 'B.S.',
            fieldOfStudy: 'Computer Science',
            institution: 'Stanford',
            location: 'Stanford, CA',
            startYear: '2022',
            endYear: '',
            isCurrentlyStudying: true,
          ),
        ],
      );

      final templates = [
        'ats',
        'modern',
        'classic',
        'minimal',
        'executive',
        'awesome',
        'academic',
        'compact',
        'elegant',
        'simple',
      ];

      for (final tid in templates) {
        final res = resume.copyWith(selectedTemplateId: TemplateId(tid));
        final bytes = await pdfService.generatePdfFromDomain(res);
        expect(bytes, isNotEmpty);
      }
    });
  });
}
