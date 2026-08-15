import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';

/// Use case for retrieving all stored resume entities.
class GetAllResumes {
  final ResumeRepository repository;

  const GetAllResumes(this.repository);

  Future<List<Resume>> call() {
    return repository.getAllResumes();
  }
}
