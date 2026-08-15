import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';

/// Use case for deleting a resume entity by ID.
class DeleteResume {
  final ResumeRepository repository;

  const DeleteResume(this.repository);

  Future<void> call(ResumeId id) {
    return repository.deleteResume(id);
  }
}
