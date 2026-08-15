import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/data/job_role_data.dart';

void main() {
  group('Job Role Data Tests', () {
    test('Job role catalogue is compiled and not empty', () {
      expect(kGlobalJobRoleCatalogue, isNotEmpty);
      expect(kGlobalJobRoleCatalogue.length, greaterThanOrEqualTo(30));
    });

    test('Job role catalogue contains major role categories', () {
      final suggestions = JobRoleDataService.getSuggestions('');
      expect(suggestions, contains('Frontend Developer'));
      expect(suggestions, contains('Backend Developer'));
      expect(suggestions, contains('Flutter Developer'));
      expect(suggestions, contains('UI/UX Designer'));
      expect(suggestions, contains('DevOps Engineer'));
    });

    test('Case-insensitive substring search works', () {
      expect(JobRoleDataService.getSuggestions('react'), contains('React Developer'));
      expect(JobRoleDataService.getSuggestions('FLUTTER'), contains('Flutter Developer'));
      expect(JobRoleDataService.getSuggestions('data'), contains('Data Analyst'));
    });
  });
}
