import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';

class DuplicateResume {
  final ResumeRepository _repository;

  const DuplicateResume(this._repository);

  Future<Resume> call(ResumeId id, [String? nameSuffix]) {
    return _repository.duplicateResume(id, nameSuffix);
  }
}
