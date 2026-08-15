import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/failures/resume_failure.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/services/resume_completion_calculator.dart';
import 'package:vitafolio/features/resume/domain/services/resume_parser.dart';
import 'package:vitafolio/features/resume/domain/services/resume_pdf_generator.dart';
import 'package:vitafolio/features/resume/domain/services/resume_validator.dart';
import 'package:vitafolio/features/resume/domain/usecases/calculate_resume_completion.dart';
import 'package:vitafolio/features/resume/domain/usecases/create_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/delete_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/generate_resume_pdf.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_all_resumes.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/parse_resume_file.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/validate_resume.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

// Pure Mock Implementations for testing Domain Use Case contract interactions
class MockResumeRepository implements ResumeRepository {
  Resume? lastCreated;
  Resume? lastUpdated;
  ResumeId? lastDeletedId;

  @override
  Future<Resume> createResume(Resume resume) async {
    lastCreated = resume;
    return resume;
  }

  @override
  Future<Resume> updateResume(Resume resume) async {
    lastUpdated = resume;
    return resume;
  }

  @override
  Future<void> deleteResume(ResumeId id) async {
    lastDeletedId = id;
  }

  @override
  Future<Resume?> getResume(ResumeId id) async {
    return lastCreated;
  }

  @override
  Future<List<Resume>> getAllResumes() async {
    return lastCreated != null ? [lastCreated!] : [];
  }

  @override
  Future<Resume> importResume(String filePath) async {
    throw UnimplementedError();
  }

  @override
  Future<Resume> parseResume(String rawText) async {
    throw UnimplementedError();
  }

  @override
  Future<Resume> saveSelectedTemplate(ResumeId resumeId, TemplateId templateId) async {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> generateResume(ResumeId resumeId) async => [1, 2, 3];

  @override
  Future<Resume> duplicateResume(ResumeId id, [String? nameSuffix]) async {
    if (lastCreated == null) throw Exception('No resume to duplicate');
    final suffix = nameSuffix ?? ' (Copy)';
    final duplicated = lastCreated!.copyWith(
      id: const ResumeId('dup-1'),
      title: '${lastCreated!.title}$suffix',
    );
    lastCreated = duplicated;
    return duplicated;
  }
}

class MockResumeParser implements ResumeParser {
  @override
  Future<Resume> parseFile(String filePath) async {
    return Resume(
      id: const ResumeId('parsed-1'),
      title: 'Parsed Resume',
      selectedTemplateId: const TemplateId('t1'),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<Resume> parseText(String rawText) async {
    throw UnimplementedError();
  }
}

class MockResumePdfGenerator implements ResumePdfGenerator {
  @override
  Future<List<int>> generatePdf(Resume resume) async => [1, 2, 3, 4, 5];

  @override
  Future<List<int>> generatePreview(Resume resume) async => [1, 2];
}

class MockResumeValidator implements ResumeValidator {
  @override
  bool isComplete(Resume resume) => true;

  @override
  List<ResumeFailure> validate(Resume resume) => [];
}

class MockResumeCompletionCalculator implements ResumeCompletionCalculator {
  @override
  double calculateProgress(Resume resume) => 0.88;

  @override
  int completedSections(Resume resume) => 8;

  @override
  int totalSections() => 9;
}

void main() {
  group('Resume Domain Use Cases Tests', () {
    late MockResumeRepository repo;
    late Resume sampleResume;

    setUp(() {
      repo = MockResumeRepository();
      sampleResume = Resume(
        id: const ResumeId('res-1'),
        title: 'Developer',
        selectedTemplateId: const TemplateId('tmpl-1'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    });

    test('CreateResume call delegates to repository', () async {
      final usecase = CreateResume(repo);
      final result = await usecase(sampleResume);

      expect(result.id, equals(const ResumeId('res-1')));
      expect(repo.lastCreated, equals(sampleResume));
    });

    test('UpdateResume call delegates to repository', () async {
      final usecase = UpdateResume(repo);
      final result = await usecase(sampleResume);

      expect(result.title, equals('Developer'));
      expect(repo.lastUpdated, equals(sampleResume));
    });

    test('DeleteResume call delegates to repository', () async {
      final usecase = DeleteResume(repo);
      await usecase(const ResumeId('res-1'));

      expect(repo.lastDeletedId, equals(const ResumeId('res-1')));
    });

    test('GetResume and GetAllResumes delegate to repository', () async {
      final createUsecase = CreateResume(repo);
      await createUsecase(sampleResume);

      final getUsecase = GetResume(repo);
      final result = await getUsecase(const ResumeId('res-1'));

      final getAllUsecase = GetAllResumes(repo);
      final allResults = await getAllUsecase();

      expect(result, equals(sampleResume));
      expect(allResults.length, equals(1));
    });

    test('ParseResumeFile delegates to parser service', () async {
      final usecase = ParseResumeFile(MockResumeParser());
      final result = await usecase('/path/to/resume.pdf');

      expect(result.title, equals('Parsed Resume'));
    });

    test('GenerateResumePdf delegates to pdf generator service', () async {
      final usecase = GenerateResumePdf(MockResumePdfGenerator());
      final bytes = await usecase(sampleResume);

      expect(bytes, equals([1, 2, 3, 4, 5]));
    });

    test('ValidateResume delegates to validator service', () {
      final usecase = ValidateResume(MockResumeValidator());
      final failures = usecase(sampleResume);
      final isComp = usecase.isComplete(sampleResume);

      expect(failures, isEmpty);
      expect(isComp, isTrue);
    });

    test('CalculateResumeCompletion delegates to calculator service', () {
      final usecase = CalculateResumeCompletion(MockResumeCompletionCalculator());

      expect(usecase(sampleResume), equals(0.88));
      expect(usecase.completedSections(sampleResume), equals(8));
      expect(usecase.totalSections(), equals(9));
    });
  });
}
