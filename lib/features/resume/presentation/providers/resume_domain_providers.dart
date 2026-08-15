import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitafolio/core/pdf/services/pdf_service.dart';
import 'package:vitafolio/core/database/database_provider.dart';
import 'package:vitafolio/features/resume/data/datasources/resume_local_datasource.dart';
import 'package:vitafolio/features/resume/data/repositories/resume_repository_impl.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/data/services/resume_parser_impl.dart';
import 'package:vitafolio/features/resume/domain/services/resume_completion_calculator.dart';
import 'package:vitafolio/features/resume/domain/services/resume_completion_calculator_impl.dart';
import 'package:vitafolio/features/resume/data/services/printing_pdf_raster_service.dart';
import 'package:vitafolio/features/resume/domain/services/pdf_raster_service.dart';
import 'package:vitafolio/features/resume/data/services/production_resume_ocr_service.dart';
import 'package:vitafolio/features/resume/domain/services/resume_ocr_service.dart';
import 'package:vitafolio/features/resume/domain/services/resume_parser.dart';
import 'package:vitafolio/features/resume/domain/services/resume_pdf_generator.dart';
import 'package:vitafolio/features/resume/domain/services/resume_validator.dart';
import 'package:vitafolio/features/resume/domain/services/resume_validator_impl.dart';
import 'package:vitafolio/features/resume/domain/usecases/calculate_resume_completion.dart';
import 'package:vitafolio/features/resume/domain/usecases/create_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/delete_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/generate_resume_pdf.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_all_resumes.dart';
import 'package:vitafolio/features/resume/domain/usecases/get_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/parse_resume_file.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/validate_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/duplicate_resume.dart';
import 'package:vitafolio/features/resume/domain/usecases/update_resume_section.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';



class DefaultResumePdfGenerator implements ResumePdfGenerator {
  final PdfService _pdfService;

  DefaultResumePdfGenerator({PdfService? pdfService})
      : _pdfService = pdfService ?? PdfService();

  @override
  Future<List<int>> generatePdf(Resume resume) async {
    final bytes = await _pdfService.generatePdfFromDomain(resume);
    return bytes.toList();
  }

  @override
  Future<List<int>> generatePreview(Resume resume) async {
    final bytes = await _pdfService.generatePdfFromDomain(resume);
    return bytes.toList();
  }
}

final resumeLocalDataSourceProvider = Provider<ResumeLocalDataSource>((ref) {
  final isar = ref.watch(isarProvider);
  return ResumeLocalDataSourceImpl(isar);
});

final resumeOcrServiceProvider = Provider<ResumeOcrService>((ref) {
  return ProductionResumeOcrService();
});

final pdfRasterServiceProvider = Provider<PdfRasterService>((ref) {
  return const PrintingPdfRasterService();
});

final resumeDomainParserProvider = Provider<ResumeParser>((ref) {
  return ResumeParserImpl(
    ocrService: ref.watch(resumeOcrServiceProvider),
    pdfRasterService: ref.watch(pdfRasterServiceProvider),
  );
});

final resumeDomainPdfGeneratorProvider = Provider<ResumePdfGenerator>((ref) {
  return DefaultResumePdfGenerator();
});

final resumeDomainValidatorProvider = Provider<ResumeValidator>((ref) {
  return const ResumeValidatorImpl();
});

final resumeDomainCompletionCalculatorProvider =
    Provider<ResumeCompletionCalculator>((ref) {
      return const ResumeCompletionCalculatorImpl();
    });

final cleanResumeRepositoryProvider = Provider<ResumeRepository>((ref) {
  return ResumeRepositoryImpl(
    localDataSource: ref.watch(resumeLocalDataSourceProvider),
    parser: ref.watch(resumeDomainParserProvider),
    pdfGenerator: ref.watch(resumeDomainPdfGeneratorProvider),
  );
});

final createResumeUseCaseProvider = Provider<CreateResume>((ref) {
  return CreateResume(ref.watch(cleanResumeRepositoryProvider));
});

final updateResumeUseCaseProvider = Provider<UpdateResume>((ref) {
  return UpdateResume(ref.watch(cleanResumeRepositoryProvider));
});

final deleteResumeUseCaseProvider = Provider<DeleteResume>((ref) {
  return DeleteResume(ref.watch(cleanResumeRepositoryProvider));
});

final getResumeUseCaseProvider = Provider<GetResume>((ref) {
  return GetResume(ref.watch(cleanResumeRepositoryProvider));
});

final getAllResumesUseCaseProvider = Provider<GetAllResumes>((ref) {
  return GetAllResumes(ref.watch(cleanResumeRepositoryProvider));
});

final parseResumeFileUseCaseProvider = Provider<ParseResumeFile>((ref) {
  return ParseResumeFile(ref.watch(resumeDomainParserProvider));
});

final generateResumePdfUseCaseProvider = Provider<GenerateResumePdf>((ref) {
  return GenerateResumePdf(ref.watch(resumeDomainPdfGeneratorProvider));
});

final validateResumeUseCaseProvider = Provider<ValidateResume>((ref) {
  return ValidateResume(ref.watch(resumeDomainValidatorProvider));
});

final calculateResumeCompletionUseCaseProvider =
    Provider<CalculateResumeCompletion>((ref) {
      return CalculateResumeCompletion(
        ref.watch(resumeDomainCompletionCalculatorProvider),
      );
    });

final duplicateResumeUseCaseProvider = Provider<DuplicateResume>((ref) {
  return DuplicateResume(ref.watch(cleanResumeRepositoryProvider));
});

final updateResumeSectionUseCaseProvider = Provider<UpdateResumeSection>((ref) {
  return UpdateResumeSection(ref.watch(cleanResumeRepositoryProvider));
});

/// Provider to track the ID of the resume currently being built/edited.
final activeResumeIdProvider = StateProvider<ResumeId?>((ref) => null);
