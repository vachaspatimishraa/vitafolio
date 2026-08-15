/// Comprehensive input validation utilities for user personal info, resume details,
/// work experience, education, projects, certifications, and languages.
class InputValidator {
  InputValidator._();

  // Regular expressions for strict validation
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9\s\-\(\)]{7,20}$');

  static final RegExp _urlRegex = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
  );

  /// Validates full name or section titles
  static String? validateName(
    String? value, {
    String fieldName = 'Name',
    int maxLength = 50,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final trimmed = value.trim();
    if (trimmed.length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters.';
    }
    return null;
  }

  /// Validates email address format
  static String? validateEmail(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Email address is required.' : null;
    }
    final trimmed = value.trim();
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Validates phone number format
  static String? validatePhone(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'Phone number is required.' : null;
    }
    final trimmed = value.trim();
    if (!_phoneRegex.hasMatch(trimmed)) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  /// Validates web URL (LinkedIn, Portfolio, GitHub, etc.)
  static String? validateUrl(String? value, {bool required = false}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'URL is required.' : null;
    }
    final trimmed = value.trim();
    if (!_urlRegex.hasMatch(trimmed)) {
      return 'Please enter a valid URL (e.g. https://linkedin.com/in/user).';
    }
    return null;
  }

  /// Validates general text fields with optional length limits
  static String? validateText(
    String? value, {
    required String fieldName,
    bool required = false,
    int? minLength,
    int? maxLength,
  }) {
    if (value == null || value.trim().isEmpty) {
      return required ? '$fieldName is required.' : null;
    }
    final trimmed = value.trim();
    if (minLength != null && trimmed.length < minLength) {
      return '$fieldName must be at least $minLength characters long.';
    }
    if (maxLength != null && trimmed.length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters.';
    }
    return null;
  }

  /// Sanitizes text input to prevent malicious script/html injection or storage corruption
  static String sanitize(String? input) {
    if (input == null) return '';
    return input
        .replaceAll(RegExp(r'<[^>]*>'), '') // Strip HTML tags
        .replaceAll(
          RegExp(r'[\u0000-\u0008\u000B-\u000C\u000E-\u001F]'),
          '',
        ) // Strip non-printable ASCII control chars
        .trim();
  }

  /// Sanitizes filename for safe export
  static String sanitizeFilename(
    String filename, {
    String fallback = 'resume',
  }) {
    final cleaned = filename
        .replaceAll(
          RegExp(r'[\\/:*?"<>|]'),
          '_',
        ) // Replace forbidden path chars
        .replaceAll(RegExp(r'\s+'), '_') // Replace spaces with underscores
        .replaceAll(RegExp(r'_+'), '_') // Deduplicate underscores
        .trim();

    if (cleaned.isEmpty || cleaned == '_') {
      return fallback;
    }
    return cleaned;
  }
}
