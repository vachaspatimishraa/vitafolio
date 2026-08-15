/// Sealed hierarchy of Resume Failure domain exceptions.
abstract class ResumeFailure {
  final String message;
  const ResumeFailure(this.message);
}

/// Triggered when resume file parsing fails.
class ParsingFailure extends ResumeFailure {
  const ParsingFailure([super.message = 'Failed to parse resume content.']);
}

/// Triggered when database CRUD operations fail.
class DatabaseFailure extends ResumeFailure {
  const DatabaseFailure([super.message = 'Database operation failed.']);
}

/// Triggered when PDF rendering or export fails.
class PdfFailure extends ResumeFailure {
  const PdfFailure([super.message = 'Failed to generate PDF document.']);
}

/// Triggered when domain validation rules are violated.
class ValidationFailure extends ResumeFailure {
  const ValidationFailure([super.message = 'Resume validation failed.']);
}

/// Fallback for unexpected system errors.
class UnknownFailure extends ResumeFailure {
  const UnknownFailure([super.message = 'An unknown error occurred.']);
}
