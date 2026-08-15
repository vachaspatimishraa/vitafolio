import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:vitafolio/features/resume/data/datasources/resume_local_datasource.dart';
import 'package:vitafolio/features/resume/data/mappers/resume_mapper.dart';
import 'package:vitafolio/features/resume/data/models/resume_model.dart';
import 'package:vitafolio/features/resume/data/repositories/resume_repository_impl.dart';
import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/failures/resume_failure.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/services/resume_completion_calculator_impl.dart';
import 'package:vitafolio/features/resume/domain/services/resume_parser.dart';
import 'package:vitafolio/features/resume/domain/services/resume_pdf_generator.dart';
import 'package:vitafolio/features/resume/domain/services/resume_validator_impl.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume_section.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

class MockParser implements ResumeParser {
  @override
  Future<Resume> parseFile(String filePath) async => throw UnimplementedError();

  @override
  Future<Resume> parseText(String rawText) async => throw UnimplementedError();
}

class MockPdfGenerator implements ResumePdfGenerator {
  @override
  Future<List<int>> generatePdf(Resume resume) async => [1, 2, 3];

  @override
  Future<List<int>> generatePreview(Resume resume) async => [1, 2];
}

void main() {
  group('Backend & Data-Layer Stabilization Tests (Task 053)', () {
    late Isar isar;
    late Directory tempDir;
    late ResumeLocalDataSource localDataSource;
    late ResumeRepository repository;
    late UpdateResumeSection updateSectionUseCase;

    final sampleResume = Resume(
      id: const ResumeId('1'),
      title: 'Alex Engineer Resume',
      selectedTemplateId: const TemplateId('ats_professional'),
      personalDetails: const PersonalDetails(
        fullName: 'Alex Engineer',
        email: 'alex@example.com',
        phoneNumber: '+1 555 0199',
        address: 'San Francisco, CA, USA',
        jobTitle: 'Senior Software Engineer',
        website: 'https://alex.dev',
        linkedinUrl: 'https://linkedin.com/in/alex',
        githubUrl: 'https://github.com/alex',
      ),
      summary: const ProfessionalSummary(
        summaryText: 'Passionate Flutter & Dart developer with 5+ years experience.',
      ),
      experiences: const [
        Experience(
          id: 'exp-1',
          jobTitle: 'Lead Mobile Architect',
          company: 'Tech Corp',
          location: 'San Francisco, CA',
          startDate: '2021-01-01',
          isCurrentRole: true,
          description: 'Architecting cross-platform apps.',
        ),
      ],
      educations: const [
        Education(
          id: 'edu-1',
          degree: 'Bachelor of Science',
          fieldOfStudy: 'Computer Science',
          institution: 'Stanford University',
          location: 'Stanford, CA',
          startYear: '2016-09-01',
          endYear: '2020-06-01',
        ),
      ],
      skills: const [
        Skill(id: 'skill-1', name: 'Flutter'),
        Skill(id: 'skill-2', name: 'Dart'),
      ],
      certifications: const [
        Certification(
          id: 'cert-1',
          name: 'AWS Developer',
          organization: 'Amazon Web Services',
          issueDate: '2022-05-01',
        ),
      ],
      languages: const [
        Language(id: 'lang-1', name: 'English', proficiencyLevel: 'Native'),
      ],
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('vitafolio_backend_test_');
      await Isar.initializeIsarCore(download: true);
      isar = await Isar.open(
        [ResumeDbModelSchema],
        directory: tempDir.path,
      );

      localDataSource = ResumeLocalDataSourceImpl(isar);
      repository = ResumeRepositoryImpl(
        localDataSource: localDataSource,
        parser: MockParser(),
        pdfGenerator: MockPdfGenerator(),
      );
      updateSectionUseCase = UpdateResumeSection(repository);
    });

    tearDown(() async {
      await isar.close(deleteFromDisk: true);
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('1. Database Initialization & Schema Registration', () async {
      expect(isar.isOpen, isTrue);
      expect(isar.collection<ResumeDbModel>(), isNotNull);
    });

    test('2. Resume CRUD Operations (Create, Read, Update, Delete)', () async {
      // Create
      final created = await repository.createResume(sampleResume);
      expect(created.title, equals('Alex Engineer Resume'));
      expect(created.id.value, isNotEmpty);

      // Read
      final fetched = await repository.getResume(created.id);
      expect(fetched, isNotNull);
      expect(fetched?.personalDetails?.fullName, equals('Alex Engineer'));

      // Update
      final updatedReq = fetched!.copyWith(title: 'Alex Senior Engineer');
      final updated = await repository.updateResume(updatedReq);
      expect(updated.title, equals('Alex Senior Engineer'));

      // Delete
      await repository.deleteResume(created.id);
      final afterDelete = await repository.getResume(created.id);
      expect(afterDelete, isNull);
    });

    test('3. Duplicate Resume Operation', () async {
      final created = await repository.createResume(sampleResume);
      final duplicated = await repository.duplicateResume(created.id, ' (Copied)');

      expect(duplicated.id.value, isNot(equals(created.id.value)));
      expect(duplicated.title, equals('Alex Engineer Resume (Copied)'));
      expect(duplicated.personalDetails?.fullName, equals('Alex Engineer'));

      // Modifying duplicate should not affect original
      final modDuplicate = duplicated.copyWith(title: 'Modified Duplicate');
      await repository.updateResume(modDuplicate);

      final original = await repository.getResume(created.id);
      expect(original?.title, equals('Alex Engineer Resume'));
    });

    test('4. Data Mapper Round-Trip Integrity', () {
      final model = ResumeMapper.toModel(sampleResume);
      model.id = 42; // Set Isar integer ID

      final domain = ResumeMapper.toDomain(model);
      expect(domain.id.value, equals('42'));
      expect(domain.title, equals(sampleResume.title));
      expect(domain.personalDetails?.fullName, equals(sampleResume.personalDetails?.fullName));
      expect(domain.experiences.length, equals(1));
      expect(domain.skills.length, equals(2));
      expect(domain.certifications.length, equals(1));
      expect(domain.languages.length, equals(1));

      final reModel = ResumeMapper.toModel(domain);
      expect(reModel.id, equals(42));
      expect(reModel.title, equals(sampleResume.title));
    });

    test('5. Partial Update Safety across Sections', () async {
      final created = await repository.createResume(sampleResume);

      // Update ONLY Summary
      final updatedResume = await updateSectionUseCase.updateSummary(
        created.id,
        const ProfessionalSummary(summaryText: 'Updated summary text only.'),
      );

      // Verify summary updated
      expect(updatedResume.summary?.summaryText, equals('Updated summary text only.'));

      // Verify all other sections remain unchanged
      expect(updatedResume.personalDetails?.fullName, equals('Alex Engineer'));
      expect(updatedResume.personalDetails?.email, equals('alex@example.com'));
      expect(updatedResume.experiences.length, equals(1));
      expect(updatedResume.educations.length, equals(1));
      expect(updatedResume.skills.length, equals(2));
      expect(updatedResume.certifications.length, equals(1));
      expect(updatedResume.languages.length, equals(1));
      expect(updatedResume.selectedTemplateId.value, equals('ats_professional'));
    });

    test('6. Personal Details Location Update Safety', () async {
      final created = await repository.createResume(sampleResume);

      final updatedDetails = created.personalDetails!.copyWith(
        address: 'London, UK',
      );

      final updatedResume = await updateSectionUseCase.updatePersonalDetails(
        created.id,
        updatedDetails,
      );

      // Address updated
      expect(updatedResume.personalDetails?.address, equals('London, UK'));

      // Contact details preserved
      expect(updatedResume.personalDetails?.fullName, equals('Alex Engineer'));
      expect(updatedResume.personalDetails?.email, equals('alex@example.com'));
      expect(updatedResume.personalDetails?.phoneNumber, equals('+1 555 0199'));
      expect(updatedResume.personalDetails?.jobTitle, equals('Senior Software Engineer'));
      expect(updatedResume.personalDetails?.website, equals('https://alex.dev'));
      expect(updatedResume.personalDetails?.linkedinUrl, equals('https://linkedin.com/in/alex'));
      expect(updatedResume.personalDetails?.githubUrl, equals('https://github.com/alex'));
    });

    test('7. Multi-Resume Isolation', () async {
      final resumeA = await repository.createResume(sampleResume);

      final sampleResumeB = sampleResume.copyWith(
        id: const ResumeId('2'),
        title: 'Bob Designer Resume',
        selectedTemplateId: const TemplateId('professional_modern'),
        personalDetails: const PersonalDetails(
          fullName: 'Bob Designer',
          email: 'bob@example.com',
          phoneNumber: '+44 20 7946 0912',
          address: 'London, UK',
        ),
      );
      final resumeB = await repository.createResume(sampleResumeB);

      final fetchedA = await repository.getResume(resumeA.id);
      final fetchedB = await repository.getResume(resumeB.id);

      expect(fetchedA?.personalDetails?.fullName, equals('Alex Engineer'));
      expect(fetchedA?.selectedTemplateId.value, equals('ats_professional'));

      expect(fetchedB?.personalDetails?.fullName, equals('Bob Designer'));
      expect(fetchedB?.selectedTemplateId.value, equals('professional_modern'));
    });

    test('8. Restart Recovery Simulation', () async {
      final created = await repository.createResume(sampleResume);
      final createdId = created.id;

      // Close and reopen Isar database
      await isar.close();
      isar = await Isar.open(
        [ResumeDbModelSchema],
        directory: tempDir.path,
      );
      localDataSource = ResumeLocalDataSourceImpl(isar);
      repository = ResumeRepositoryImpl(
        localDataSource: localDataSource,
        parser: MockParser(),
        pdfGenerator: MockPdfGenerator(),
      );

      final restored = await repository.getResume(createdId);
      expect(restored, isNotNull);
      expect(restored?.title, equals('Alex Engineer Resume'));
      expect(restored?.personalDetails?.fullName, equals('Alex Engineer'));
      expect(restored?.skills.length, equals(2));
    });

    test('9. Resume Validation & Completion Calculator', () {
      const validator = ResumeValidatorImpl();
      final failures = validator.validate(sampleResume);
      expect(failures, isEmpty);
      expect(validator.isComplete(sampleResume), isTrue);

      const calculator = ResumeCompletionCalculatorImpl();
      final progress = calculator.calculateProgress(sampleResume);
      expect(progress, greaterThan(0.8));
    });

    test('10. Error Handling & Exception Behavior', () async {
      expect(
        () async => await repository.deleteResume(const ResumeId('invalid-non-numeric')),
        throwsA(isA<DatabaseFailure>()),
      );
    });
  });
}
