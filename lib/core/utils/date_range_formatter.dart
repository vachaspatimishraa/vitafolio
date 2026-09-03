/// Canonical centralized date and date-range formatter for Vitafolio.
///
/// Ensures consistent, null-safe date rendering across Preview, PDF, DOCX/Word,
/// and all 10 resume templates with zero dangling dashes or null strings.
class DateRangeFormatter {
  const DateRangeFormatter._();

  static const String defaultSeparator = ' – ';
  static const String asciiSeparator = ' - ';

  /// Formats a single [DateTime] to "MMM yyyy" (e.g. "Jan 2024") or "yyyy" if [includeMonth] is false.
  static String formatDate(DateTime? date, {bool includeMonth = true}) {
    if (date == null) return '';
    if (!includeMonth) return '${date.year}';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (date.month < 1 || date.month > 12) return '${date.year}';
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Formats a generic date or year range with strict null-safety and no dangling separators.
  ///
  /// Matrix:
  /// - Both [start] and [end] present -> "$start$separator$end"
  /// - Only [start] present -> "$start" (or "$start$separator$ongoingLabel" if [isOngoing])
  /// - Only [end] present -> "$end"
  /// - Neither present -> ""
  static String formatRange({
    String? start,
    String? end,
    bool isOngoing = false,
    String ongoingLabel = 'Present',
    String separator = defaultSeparator,
  }) {
    final cleanStart = start?.trim() ?? '';
    final cleanEnd = isOngoing
        ? ongoingLabel
        : (end?.trim() ?? '');

    if (cleanStart.isNotEmpty && cleanEnd.isNotEmpty) {
      return '$cleanStart$separator$cleanEnd';
    }
    if (cleanStart.isNotEmpty) {
      return cleanStart;
    }
    if (cleanEnd.isNotEmpty) {
      return cleanEnd;
    }
    return '';
  }

  /// Parses various date representations (ISO-8601, 4-digit year, "MMM yyyy", "05/2023", etc.) into a [DateTime].
  static DateTime? parseDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final trimmed = raw.trim();

    // 1. Try standard ISO-8601 (e.g. "2023-05-15")
    final iso = DateTime.tryParse(trimmed);
    if (iso != null) return iso;

    // 2. Try 4-digit year (e.g. "2024", "1999")
    final yearOnly = int.tryParse(trimmed);
    if (yearOnly != null && yearOnly >= 1900 && yearOnly <= 2100) {
      return DateTime(yearOnly, 1, 1);
    }

    // 3. Try "MMM yyyy" or "Month yyyy" (e.g. "Jan 2023", "May 2024")
    const monthMap = {
      'jan': 1, 'january': 1,
      'feb': 2, 'february': 2,
      'mar': 3, 'march': 3,
      'apr': 4, 'april': 4,
      'may': 5,
      'jun': 6, 'june': 6,
      'jul': 7, 'july': 7,
      'aug': 8, 'august': 8,
      'sep': 9, 'sept': 9, 'september': 9,
      'oct': 10, 'october': 10,
      'nov': 11, 'november': 11,
      'dec': 12, 'december': 12,
    };

    final tokens = trimmed.split(RegExp(r'[\s,/\-]+')).where((t) => t.isNotEmpty).toList();
    if (tokens.length == 2) {
      final t0 = tokens[0].toLowerCase();
      final t1 = tokens[1].toLowerCase();

      if (monthMap.containsKey(t0) && int.tryParse(t1) != null) {
        final y = int.parse(t1);
        return DateTime(y, monthMap[t0]!, 1);
      } else if (int.tryParse(t0) != null && monthMap.containsKey(t1)) {
        final y = int.parse(t0);
        return DateTime(y, monthMap[t1]!, 1);
      } else if (int.tryParse(t0) != null && int.tryParse(t1) != null) {
        final n0 = int.parse(t0);
        final n1 = int.parse(t1);
        if (n0 >= 1 && n0 <= 12 && n1 >= 1900 && n1 <= 2100) {
          return DateTime(n1, n0, 1);
        } else if (n0 >= 1900 && n0 <= 2100 && n1 >= 1 && n1 <= 12) {
          return DateTime(n0, n1, 1);
        }
      }
    }

    return null;
  }

  /// Formats an Education date range using Education-specific semantics ("Pursuing").
  static String formatEducation({
    String? startYear,
    String? endYear,
    DateTime? startDate,
    DateTime? endDate,
    bool isCurrentlyStudying = false,
    String ongoingLabel = 'Pursuing',
    String separator = defaultSeparator,
  }) {
    final start = (startYear != null && startYear.trim().isNotEmpty)
        ? startYear.trim()
        : (startDate != null ? '${startDate.year}' : '');

    final end = (endYear != null && endYear.trim().isNotEmpty)
        ? endYear.trim()
        : (endDate != null ? '${endDate.year}' : '');

    return formatRange(
      start: start,
      end: end,
      isOngoing: isCurrentlyStudying,
      ongoingLabel: ongoingLabel,
      separator: separator,
    );
  }

  /// Formats an Experience date range using Experience-specific semantics ("Present").
  static String formatExperience({
    String? startDateStr,
    String? endDateStr,
    DateTime? startDate,
    DateTime? endDate,
    bool isCurrentRole = false,
    String ongoingLabel = 'Present',
    String separator = defaultSeparator,
  }) {
    final start = (startDateStr != null && startDateStr.trim().isNotEmpty)
        ? startDateStr.trim()
        : formatDate(startDate);

    final end = (endDateStr != null && endDateStr.trim().isNotEmpty)
        ? endDateStr.trim()
        : formatDate(endDate);

    return formatRange(
      start: start,
      end: end,
      isOngoing: isCurrentRole,
      ongoingLabel: ongoingLabel,
      separator: separator,
    );
  }
}
