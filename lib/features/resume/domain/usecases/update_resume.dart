import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';

/// Use case for updating an existing resume entity.
class UpdateResume {
  final ResumeRepository repository;

  const UpdateResume(this.repository);

  Future<Resume> call(Resume resume) {
    return repository.updateResume(resume);
  }
}
