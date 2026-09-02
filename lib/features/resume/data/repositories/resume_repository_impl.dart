import 'package:vitafolio/features/resume/data/datasources/resume_local_datasource.dart';
import 'package:vitafolio/features/resume/data/mappers/resume_mapper.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/failures/resume_failure.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/services/resume_parser.dart';
import 'package:vitafolio/features/resume/domain/services/resume_pdf_generator.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

class ResumeRepositoryImpl implements ResumeRepository {
  final ResumeLocalDataSource _localDataSource;
  final ResumeParser _parser;
  final ResumePdfGenerator _pdfGenerator;

  ResumeRepositoryImpl({
    required ResumeLocalDataSource localDataSource,
    required ResumeParser parser,
    required ResumePdfGenerator pdfGenerator,
  })  : _localDataSource = localDataSource,
        _parser = parser,
        _pdfGenerator = pdfGenerator;

  @override
  Future<Resume> createResume(Resume resume) async {
    try {
      final model = ResumeMapper.toModel(resume);
      final savedModel = await _localDataSource.createResume(model);
      return ResumeMapper.toDomain(savedModel);
    } catch (e) {
      throw const DatabaseFailure();
    }
  }

  @override
  Future<Resume> updateResume(Resume resume) async {
    try {
      final model = ResumeMapper.toModel(resume);
      final updatedModel = await _localDataSource.updateResume(model);
      return ResumeMapper.toDomain(updatedModel);
    } catch (e) {
      throw const DatabaseFailure();
    }
  }

  @override
  Future<void> deleteResume(ResumeId id) async {
    try {
      final intId = int.tryParse(id.value);
      if (intId == null) throw const DatabaseFailure('Invalid ID format');
      await _localDataSource.deleteResume(intId);
    } catch (e) {
      if (e is DatabaseFailure) rethrow;
      throw const DatabaseFailure();
    }
  }

  @override
  Future<Resume?> getResume(ResumeId id) async {
    try {
      final intId = int.tryParse(id.value);
      if (intId == null) return null;
      final model = await _localDataSource.getResume(intId);
      return model != null ? ResumeMapper.toDomain(model) : null;
    } catch (e) {
      throw const DatabaseFailure();
    }
  }

  @override
  Future<List<Resume>> getAllResumes() async {
    try {
      final models = await _localDataSource.getAllResumes();
      return models.map(ResumeMapper.toDomain).toList();
    } catch (e) {
      throw const DatabaseFailure();
    }
  }

  @override
  Future<Resume> importResume(String filePath) async {
    try {
      final parsedResume = await _parser.parseFile(filePath);
      return await createResume(parsedResume);
    } on ParsingFailure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure('Failed to import resume');
    }
  }

  @override
  Future<Resume> parseResume(String rawText) async {
    try {
      return await _parser.parseText(rawText);
    } on ParsingFailure {
      rethrow;
    } catch (e) {
      throw const ParsingFailure();
    }
  }

  @override
  Future<Resume> saveSelectedTemplate(ResumeId resumeId, TemplateId templateId) async {
    try {
      final intId = int.tryParse(resumeId.value);
      if (intId == null) throw const DatabaseFailure('Invalid ID format');
      await _localDataSource.saveSelectedTemplate(intId, templateId.value);
      final updatedResume = await getResume(resumeId);
      if (updatedResume == null) throw const DatabaseFailure('Resume not found after update');
      return updatedResume;
    } catch (e) {
      if (e is DatabaseFailure) rethrow;
      throw const DatabaseFailure();
    }
  }

  @override
  Future<Resume> saveSelectedFont(ResumeId resumeId, String fontFamily) async {
    try {
      final intId = int.tryParse(resumeId.value);
      if (intId == null) throw const DatabaseFailure('Invalid ID format');
      await _localDataSource.saveSelectedFont(intId, fontFamily);
      final updatedResume = await getResume(resumeId);
      if (updatedResume == null) throw const DatabaseFailure('Resume not found after update');
      return updatedResume;
    } catch (e) {
      if (e is DatabaseFailure) rethrow;
      throw const DatabaseFailure();
    }
  }

  @override
  Future<List<int>> generateResume(ResumeId resumeId) async {
    try {
      final resume = await getResume(resumeId);
      if (resume == null) throw const DatabaseFailure('Resume not found');
      return await _pdfGenerator.generatePdf(resume);
    } on PdfFailure {
      rethrow;
    } catch (e) {
      if (e is DatabaseFailure) rethrow;
      throw const PdfFailure();
    }
  }

  @override
  Future<Resume> duplicateResume(ResumeId id, [String? nameSuffix]) async {
    try {
      final intId = int.tryParse(id.value);
      if (intId == null) throw const DatabaseFailure('Invalid ID format');
      final duplicatedModel = await _localDataSource.duplicateResume(intId, nameSuffix);
      return ResumeMapper.toDomain(duplicatedModel);
    } catch (e) {
      if (e is DatabaseFailure) rethrow;
      throw const DatabaseFailure();
    }
  }
}
