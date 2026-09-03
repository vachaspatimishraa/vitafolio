import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/utils/date_range_formatter.dart';

void main() {
  group('DateRangeFormatter', () {
    test('formatDate formats DateTime to MMM yyyy correctly', () {
      final date = DateTime(2023, 5, 15);
      expect(DateRangeFormatter.formatDate(date), 'May 2023');
      expect(DateRangeFormatter.formatDate(date, includeMonth: false), '2023');
      expect(DateRangeFormatter.formatDate(null), '');
    });

    test('formatRange with both start and end formats clean range', () {
      expect(
        DateRangeFormatter.formatRange(start: '2020', end: '2024'),
        '2020 – 2024',
      );
      expect(
        DateRangeFormatter.formatRange(start: '2020', end: '2024', separator: ' - '),
        '2020 - 2024',
      );
    });

    test('formatRange with only start returns start without dangling separator', () {
      expect(DateRangeFormatter.formatRange(start: '2020', end: null), '2020');
      expect(DateRangeFormatter.formatRange(start: '2020', end: ''), '2020');
      expect(DateRangeFormatter.formatRange(start: '  2020  ', end: '   '), '2020');
    });

    test('formatRange with only end returns end without dangling separator', () {
      expect(DateRangeFormatter.formatRange(start: null, end: '2024'), '2024');
      expect(DateRangeFormatter.formatRange(start: '', end: '2024'), '2024');
      expect(DateRangeFormatter.formatRange(start: '   ', end: '  2024  '), '2024');
    });

    test('formatRange with neither start nor end returns empty string', () {
      expect(DateRangeFormatter.formatRange(start: null, end: null), '');
      expect(DateRangeFormatter.formatRange(start: '', end: ''), '');
      expect(DateRangeFormatter.formatRange(start: '  ', end: '   '), '');
    });

    test('formatEducation formats ongoing education with Pursuing', () {
      expect(
        DateRangeFormatter.formatEducation(
          startYear: '2022',
          isCurrentlyStudying: true,
        ),
        '2022 – Pursuing',
      );
      expect(
        DateRangeFormatter.formatEducation(
          startYear: '2022',
          endYear: '2026',
          isCurrentlyStudying: true, // ongoing overrides endYear
        ),
        '2022 – Pursuing',
      );
    });

    test('formatEducation formats completed education correctly', () {
      expect(
        DateRangeFormatter.formatEducation(
          startYear: '2018',
          endYear: '2022',
          isCurrentlyStudying: false,
        ),
        '2018 – 2022',
      );
      expect(
        DateRangeFormatter.formatEducation(
          startYear: '2018',
          endYear: null,
          isCurrentlyStudying: false,
        ),
        '2018',
      );
      expect(
        DateRangeFormatter.formatEducation(
          startYear: null,
          endYear: '2022',
          isCurrentlyStudying: false,
        ),
        '2022',
      );
      expect(
        DateRangeFormatter.formatEducation(
          startYear: null,
          endYear: null,
          isCurrentlyStudying: false,
        ),
        '',
      );
    });

    test('formatExperience formats ongoing role with Present', () {
      expect(
        DateRangeFormatter.formatExperience(
          startDateStr: '2021',
          isCurrentRole: true,
        ),
        '2021 – Present',
      );
      expect(
        DateRangeFormatter.formatExperience(
          startDateStr: 'Jan 2021',
          endDateStr: 'Dec 2023',
          isCurrentRole: true, // ongoing overrides end
        ),
        'Jan 2021 – Present',
      );
    });

    test('formatExperience formats completed role correctly', () {
      expect(
        DateRangeFormatter.formatExperience(
          startDateStr: 'Jan 2020',
          endDateStr: 'Jan 2023',
          isCurrentRole: false,
        ),
        'Jan 2020 – Jan 2023',
      );
      expect(
        DateRangeFormatter.formatExperience(
          startDateStr: '2020',
          endDateStr: null,
          isCurrentRole: false,
        ),
        '2020',
      );
      expect(
        DateRangeFormatter.formatExperience(
          startDateStr: null,
          endDateStr: '2023',
          isCurrentRole: false,
        ),
        '2023',
      );
      expect(
        DateRangeFormatter.formatExperience(
          startDateStr: null,
          endDateStr: null,
          isCurrentRole: false,
        ),
        '',
      );
    });

    test('parseDate parses ISO, year-only, and MMM yyyy formats', () {
      expect(DateRangeFormatter.parseDate('2023-05-15'), DateTime(2023, 5, 15));
      expect(DateRangeFormatter.parseDate('2024'), DateTime(2024, 1, 1));
      expect(DateRangeFormatter.parseDate('May 2023'), DateTime(2023, 5, 1));
      expect(DateRangeFormatter.parseDate('Jan 2021'), DateTime(2021, 1, 1));
      expect(DateRangeFormatter.parseDate('05/2023'), DateTime(2023, 5, 1));
      expect(DateRangeFormatter.parseDate('2023/05'), DateTime(2023, 5, 1));
      expect(DateRangeFormatter.parseDate(''), null);
      expect(DateRangeFormatter.parseDate('   '), null);
      expect(DateRangeFormatter.parseDate(null), null);
      expect(DateRangeFormatter.parseDate('invalid-date'), null);
    });

    test('formatEducation with DateTime formats year without fake month', () {
      final start = DateTime(2020, 1, 1);
      final end = DateTime(2024, 1, 1);
      expect(
        DateRangeFormatter.formatEducation(startDate: start, endDate: end),
        '2020 – 2024',
      );
      expect(
        DateRangeFormatter.formatEducation(startDate: start, isCurrentlyStudying: true),
        '2020 – Pursuing',
      );
    });

    test('formatExperience with DateTime formats MMM yyyy', () {
      final start = DateTime(2020, 5, 1);
      final end = DateTime(2023, 12, 1);
      expect(
        DateRangeFormatter.formatExperience(startDate: start, endDate: end),
        'May 2020 – Dec 2023',
      );
      expect(
        DateRangeFormatter.formatExperience(startDate: start, isCurrentRole: true),
        'May 2020 – Present',
      );
    });
  });
}
