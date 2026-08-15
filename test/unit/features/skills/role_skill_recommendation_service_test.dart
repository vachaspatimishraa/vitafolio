import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/features/skills/domain/services/role_skill_recommendation_service.dart';

void main() {
  group('RoleSkillRecommendationService Tests', () {
    test('Normalizes job roles correctly', () {
      expect(RoleSkillRecommendationService.normalizeJobRole('Frontend Developer'), 'frontend');
      expect(RoleSkillRecommendationService.normalizeJobRole('Front-End Engineer'), 'frontend');
      expect(RoleSkillRecommendationService.normalizeJobRole('Backend Developer'), 'backend');
      expect(RoleSkillRecommendationService.normalizeJobRole('Flutter Developer'), 'flutter');
      expect(RoleSkillRecommendationService.normalizeJobRole('UI/UX Designer'), 'ui_ux');
    });

    test('Generates role-specific recommendations', () {
      final frontendRecs = RoleSkillRecommendationService.getRecommendedSkills(
        jobRole: 'Frontend Developer',
        selectedSkills: [],
      );
      expect(frontendRecs, contains('React'));
      expect(frontendRecs, contains('HTML5'));

      final backendRecs = RoleSkillRecommendationService.getRecommendedSkills(
        jobRole: 'Backend Developer',
        selectedSkills: [],
      );
      expect(backendRecs, contains('Node.js'));
      expect(backendRecs, contains('PostgreSQL'));
    });

    test('Excludes already selected skills from recommendations', () {
      final recs = RoleSkillRecommendationService.getRecommendedSkills(
        jobRole: 'Frontend Developer',
        selectedSkills: ['React', 'TypeScript'],
      );
      expect(recs, isNot(contains('React')));
      expect(recs, isNot(contains('TypeScript')));
      expect(recs, contains('JavaScript'));
    });

    test('Empty job role returns sensible fallback recommendations', () {
      final recs = RoleSkillRecommendationService.getRecommendedSkills(
        jobRole: '',
        selectedSkills: [],
      );
      expect(recs, isNotEmpty);
      expect(recs, contains('Communication'));
    });
  });
}
