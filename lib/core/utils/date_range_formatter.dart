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
        : formatDate(startDate);

    final end = (endYear != null && endYear.trim().isNotEmpty)
        ? endYear.trim()
        : formatDate(endDate);

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
