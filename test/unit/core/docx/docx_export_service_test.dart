import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/docx/docx_export_service.dart';
import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

void main() {
  group('DocxExportService Tests', () {
    const docxService = DocxExportService();

    final testResume = Resume(
      id: const ResumeId('test_res_1'),
      title: 'Senior Flutter Architect',
      selectedTemplateId: const TemplateId('modern'),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      personalDetails: const PersonalDetails(
        fullName: 'Jane Doe',
        jobTitle: 'Principal Mobile Architect',
        email: 'jane.doe@example.com',
        phoneNumber: '+1 555-0199',
        address: 'San Francisco, CA',
        linkedinUrl: 'linkedin.com/in/janedoe',
        githubUrl: 'github.com/janedoe',
        website: 'https://janedoe.dev',
      ),
      summary: const ProfessionalSummary(
        summaryText:
            'Distinguished mobile architect with 10+ years designing enterprise applications.',
      ),
      experiences: const [
        Experience(
          id: 'exp-1',
          jobTitle: 'Lead Flutter Engineer',
          company: 'Acme Corp',
          location: 'San Francisco, CA',
          startDate: '2021',
          endDate: 'Present',
          isCurrentRole: true,
          description:
              'Architected offline-first Flutter application with 1M+ active users.\n• Built real-time rendering engine.',
        ),
        Experience(
          id: 'exp-2',
          jobTitle: 'Senior Software Engineer',
          company: 'Tech Solutions Inc',
          location: 'New York, NY',
          startDate: '2018',
          endDate: '2021',
          isCurrentRole: false,
          description:
              'Developed scalable microservices and cross-platform clients.',
        ),
      ],
      educations: const [
        Education(
          id: 'edu-1',
          institution: 'Stanford University',
          degree: 'Master of Science',
          fieldOfStudy: 'Computer Science',
          location: 'Stanford, CA',
          startYear: '2016',
          endYear: '2018',
          grade: '3.9 GPA',
        ),
      ],
      skills: const [
        Skill(id: 's-1', name: 'Flutter'),
        Skill(id: 's-2', name: 'Dart'),
        Skill(id: 's-3', name: 'Riverpod'),
        Skill(id: 's-4', name: 'Isar DB'),
      ],
      projects: const [
        Project(
          id: 'p-1',
          name: 'Vitafolio Resume Builder',
          role: 'Lead Architect',
          description:
              'Production resume creation suite supporting PDF and DOCX exports.',
          technologies: ['Flutter', 'Dart', 'OpenXML'],
        ),
      ],
      certifications: const [
        Certification(
          id: 'c-1',
          name: 'Google Cloud Professional Architect',
          organization: 'Google Cloud',
          issueDate: '2023',
        ),
      ],
      languages: const [
        Language(id: 'l-1', name: 'English', proficiencyLevel: 'Native'),
        Language(id: 'l-2', name: 'Spanish', proficiencyLevel: 'Professional'),
      ],
    );

    test('generates a non-empty .docx byte buffer', () {
      final bytes = docxService.generateDocx(testResume);
      expect(bytes, isNotEmpty);
      expect(bytes.length, greaterThan(1000));
    });

    test('generates valid ZIP archive containing required OpenXML parts', () {
      final bytes = docxService.generateDocx(testResume);
      final zipDecoder = ZipDecoder();
      final archive = zipDecoder.decodeBytes(bytes);

      final fileNames = archive.files.map((f) => f.name).toSet();
      expect(fileNames, contains('[Content_Types].xml'));
      expect(fileNames, contains('_rels/.rels'));
      expect(fileNames, contains('word/_rels/document.xml.rels'));
      expect(fileNames, contains('word/styles.xml'));
      expect(fileNames, contains('word/document.xml'));
    });

    test('word/document.xml contains all candidate and section information', () {
      final bytes = docxService.generateDocx(testResume);
      final zipDecoder = ZipDecoder();
      final archive = zipDecoder.decodeBytes(bytes);
      final docFile = archive.findFile('word/document.xml');

      expect(docFile, isNotNull);
      final docXml = utf8.decode(docFile!.content as List<int>);

      expect(docXml, contains('Jane Doe'));
      expect(docXml, contains('Principal Mobile Architect'));
      expect(docXml, contains('jane.doe@example.com'));
      expect(docXml, contains('PROFESSIONAL SUMMARY'));
      expect(docXml, contains('WORK EXPERIENCE'));
      expect(docXml, contains('Lead Flutter Engineer'));
      expect(docXml, contains('Acme Corp'));
      expect(docXml, contains('PROJECTS'));
      expect(docXml, contains('Vitafolio Resume Builder'));
      expect(docXml, contains('EDUCATION'));
      expect(docXml, contains('Stanford University'));
      expect(docXml, contains('SKILLS'));
      expect(docXml, contains('Flutter'));
      expect(docXml, contains('CERTIFICATIONS'));
      expect(docXml, contains('Google Cloud Professional Architect'));
      expect(docXml, contains('LANGUAGES'));
      expect(docXml, contains('English'));
    });
  });
}
