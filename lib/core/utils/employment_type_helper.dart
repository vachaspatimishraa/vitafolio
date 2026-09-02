/// Helper for normalizing and safely selecting employment types in dropdowns.
class EmploymentTypeHelper {
  const EmploymentTypeHelper._();

  static const List<String> standardOptions = [
    'Full-Time',
    'Part-Time',
    'Internship',
    'Contract',
    'Freelance',
    'Temporary',
  ];

  /// Normalizes legacy or varied casing employment types to canonical forms.
  static String? normalizeEmploymentType(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final lower = trimmed.toLowerCase();

    if (lower == 'full-time' || lower == 'full time' || lower == 'fulltime') {
      return 'Full-Time';
    }
    if (lower == 'part-time' || lower == 'part time' || lower == 'parttime') {
      return 'Part-Time';
    }
    if (lower == 'internship' || lower == 'intern') {
      return 'Internship';
    }
    if (lower == 'contract' || lower == 'contractor') {
      return 'Contract';
    }
    if (lower == 'freelance' || lower == 'freelancer') {
      return 'Freelance';
    }
    if (lower == 'temporary' || lower == 'temp') {
      return 'Temporary';
    }

    // If exact match with any standard option (case-insensitive)
    for (final opt in standardOptions) {
      if (opt.toLowerCase() == lower) {
        return opt;
      }
    }

    return null;
  }

  /// Returns a valid value matching [allowedOptions] for DropdownButtonFormField, or null.
  static String? getSafeDropdownValue(
    String? value, [
    List<String>? allowedOptions,
  ]) {
    final normalized = normalizeEmploymentType(value);
    if (normalized == null) return null;

    final options = allowedOptions ?? standardOptions;
    if (options.contains(normalized)) {
      return normalized;
    }

    // Try case-insensitive or space-varied match in options
    for (final opt in options) {
      if (normalizeEmploymentType(opt) == normalized) {
        return opt;
      }
    }

    return null;
  }
}
