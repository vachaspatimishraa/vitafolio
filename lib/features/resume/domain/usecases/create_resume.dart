import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';

/// Use case for creating a new resume entity.
class CreateResume {
  final ResumeRepository repository;

  const CreateResume(this.repository);

  Future<Resume> call(Resume resume) {
    return repository.createResume(resume);
  }
}
