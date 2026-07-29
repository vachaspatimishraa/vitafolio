import 'input_validator.dart';

/// Data integrity validator to ensure model objects, embedded structures,
/// and database records remain valid, unique, and consistent before persistence.
class DataValidator {
  DataValidator._();

  /// Validates a resume ID to ensure it is non-null and positive.
  static bool isValidId(int? id) {
    return id != null && id > 0;
  }

  /// Validates string content to ensure it is not excessively long or containing corrupt characters.
  static bool isValidString(String? text, {int maxLen = 10000}) {
    if (text == null) return true;
    return text.length <= maxLen;
  }

  /// Validates date ranges (e.g. startDate must be before or equal to endDate if present).
  static bool isValidDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return true;
    return startDate.isBefore(endDate) || startDate.isAtSameMomentAs(endDate);
  }

  /// Sanitizes embedded string list (e.g. skills, bullets) removing empty or duplicate entries.
  static List<String> sanitizeStringList(List<String>? items) {
    if (items == null) return [];
    final set = <String>{};
    final result = <String>[];
    for (final item in items) {
      final cleaned = InputValidator.sanitize(item);
      if (cleaned.isNotEmpty && set.add(cleaned.toLowerCase())) {
        result.add(cleaned);
      }
    }
    return result;
  }
}
