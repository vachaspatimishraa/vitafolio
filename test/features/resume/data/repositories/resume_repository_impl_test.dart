import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/resume/data/datasources/resume_local_datasource.dart';
import 'package:vitafolio/features/resume/data/models/resume_model.dart';
import 'package:vitafolio/features/resume/data/repositories/resume_repository_impl.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/services/resume_parser.dart';
import 'package:vitafolio/features/resume/domain/services/resume_pdf_generator.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

class MockLocalDataSource implements ResumeLocalDataSource {
  ResumeDbModel? resumeToReturn;
  List<ResumeDbModel> resumesToReturn = [];
  bool deleteCalled = false;

  @override
  Future<ResumeDbModel> createResume(ResumeDbModel resume) async {
    resume.id = 1;
    return resume;
  }

  @override
  Future<void> deleteResume(int id) async {
    deleteCalled = true;
  }

  @override
  Future<List<ResumeDbModel>> getAllResumes() async => resumesToReturn;

  @override
  Future<ResumeDbModel?> getResume(int id) async => resumeToReturn;

  @override
  Future<void> saveSelectedTemplate(int resumeId, String templateId) async {}

  @override
  Future<ResumeDbModel> updateResume(ResumeDbModel resume) async => resume;

  @override
  Future<ResumeDbModel> duplicateResume(int id, [String? nameSuffix]) async {
    return resumeToReturn ?? ResumeDbModel();
  }
}

class MockParser implements ResumeParser {
  @override
  Future<Resume> parseFile(String filePath) {
    throw UnimplementedError();
  }

  @override
  Future<Resume> parseText(String rawText) {
    throw UnimplementedError();
  }
}

class MockPdfGenerator implements ResumePdfGenerator {
  @override
  Future<List<int>> generatePdf(Resume resume) {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> generatePreview(Resume resume) {
    throw UnimplementedError();
  }
}

void main() {
  late ResumeRepositoryImpl repository;
  late MockLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockLocalDataSource();
    repository = ResumeRepositoryImpl(
      localDataSource: mockDataSource,
      parser: MockParser(),
      pdfGenerator: MockPdfGenerator(),
    );
  });

  test('createResume should call dataSource', () async {
    final now = DateTime.now();
    final resume = Resume(
      id: const ResumeId(''),
      title: 'Title',
      selectedTemplateId: const TemplateId('temp'),
      createdAt: now,
      updatedAt: now,
    );

    final result = await repository.createResume(resume);

    expect(result.id.value, '1');
  });

  test('deleteResume should call dataSource with int ID', () async {
    await repository.deleteResume(const ResumeId('123'));
    expect(mockDataSource.deleteCalled, true);
  });
}
