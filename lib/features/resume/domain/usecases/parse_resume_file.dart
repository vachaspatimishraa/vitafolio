import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/services/resume_parser.dart';

/// Use case for parsing uploaded resume files into structured Resume domain entities.
class ParseResumeFile {
  final ResumeParser parser;

  const ParseResumeFile(this.parser);

  Future<Resume> call(String filePath) {
    return parser.parseFile(filePath);
  }
}
