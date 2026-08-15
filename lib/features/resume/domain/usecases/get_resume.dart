import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';

/// Use case for retrieving a single resume entity by ID.
class GetResume {
  final ResumeRepository repository;

  const GetResume(this.repository);

  Future<Resume?> call(ResumeId id) {
    return repository.getResume(id);
  }
}
