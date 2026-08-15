import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/data/skill_data.dart';

void main() {
  group('Compiled Skill Data Tests', () {
    final skillService = const SkillDataService();

    test('Skill catalogue is not empty', () {
      expect(kGlobalSkillCatalogue, isNotEmpty);
      expect(kGlobalSkillCatalogue.length, greaterThanOrEqualTo(50));
    });

    test('Skill lookups contain required domains', () {
      final suggestions = skillService.getSuggestions('');
      expect(suggestions, contains('Flutter'));
      expect(suggestions, contains('Dart'));
      expect(suggestions, contains('Python'));
      expect(suggestions, contains('React'));
      expect(suggestions, contains('GraphQL'));
      expect(suggestions, contains('Kubernetes'));
      expect(suggestions, contains('Figma'));
    });

    test('Case-insensitive substring skill filtering', () {
      expect(skillService.getSuggestions('flut'), contains('Flutter'));
      expect(skillService.getSuggestions('FLUT'), contains('Flutter'));
      expect(skillService.getSuggestions('graph'), contains('GraphQL'));
      expect(skillService.getSuggestions('PYTHON'), contains('Python'));
    });
  });
}
