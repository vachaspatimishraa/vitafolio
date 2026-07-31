import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/pdf/helpers/pdf_section_helper.dart';
import 'package:vitafolio/data/models/embedded/certification_model.dart';
import 'package:vitafolio/data/models/embedded/education_model.dart';
import 'package:vitafolio/data/models/embedded/experience_model.dart';
import 'package:vitafolio/data/models/embedded/language_model.dart';
import 'package:vitafolio/data/models/embedded/project_model.dart';
import 'package:vitafolio/data/models/embedded/skill_model.dart';

void main() {
  group('PdfSectionHelper', () {
    test('hasSummary returns correct boolean', () {
      expect(PdfSectionHelper.hasSummary(null), false);
      expect(PdfSectionHelper.hasSummary(''), false);
      expect(PdfSectionHelper.hasSummary('   '), false);
      expect(PdfSectionHelper.hasSummary('Software Engineer'), true);
    });

    test('hasExperience and validExperiences handle empty and valid data', () {
      expect(PdfSectionHelper.hasExperience(null), false);
      expect(PdfSectionHelper.hasExperience([]), false);

      final emptyItem = ExperienceModel(company: '  ', position: '', description: null);
      expect(PdfSectionHelper.hasExperience([emptyItem]), false);
      expect(PdfSectionHelper.validExperiences([emptyItem]), isEmpty);

      final validItem = ExperienceModel(company: 'Google', position: 'Developer');
      expect(PdfSectionHelper.hasExperience([emptyItem, validItem]), true);
      expect(PdfSectionHelper.validExperiences([emptyItem, validItem]).length, 1);
    });

    test('hasEducation and validEducation handle empty and valid data', () {
      expect(PdfSectionHelper.hasEducation(null), false);
      final emptyItem = EducationModel(school: '', degree: '  ');
      expect(PdfSectionHelper.hasEducation([emptyItem]), false);

      final validItem = EducationModel(school: 'MIT');
      expect(PdfSectionHelper.hasEducation([emptyItem, validItem]), true);
      expect(PdfSectionHelper.validEducation([emptyItem, validItem]).length, 1);
    });

    test('hasSkills and skill filtering handle models and strings', () {
      expect(PdfSectionHelper.hasSkills(null), false);
      expect(PdfSectionHelper.hasSkills(<SkillModel>[]), false);
      expect(PdfSectionHelper.hasSkills(<String>[]), false);

      final emptyModel = SkillModel(name: '  ');
      final validModel = SkillModel(name: 'Flutter');
      expect(PdfSectionHelper.hasSkills([emptyModel]), false);
      expect(PdfSectionHelper.hasSkills([emptyModel, validModel]), true);
      expect(PdfSectionHelper.validSkillModels([emptyModel, validModel]).length, 1);

      final stringList = ['  ', 'Dart'];
      expect(PdfSectionHelper.hasSkills(stringList), true);
      expect(PdfSectionHelper.validSkillStrings(stringList), ['Dart']);
    });

    test('hasProjects and validProjects handle empty and valid data', () {
      expect(PdfSectionHelper.hasProjects(null), false);
      final emptyItem = ProjectModel(projectName: '  ', description: '');
      expect(PdfSectionHelper.hasProjects([emptyItem]), false);

      final validItem = ProjectModel(projectName: 'Vitafolio');
      expect(PdfSectionHelper.hasProjects([emptyItem, validItem]), true);
      expect(PdfSectionHelper.validProjects([emptyItem, validItem]).length, 1);
    });

    test('hasCertifications and validCertifications handle empty and valid data', () {
      expect(PdfSectionHelper.hasCertifications(null), false);
      final emptyItem = CertificationModel(certificateName: '', organization: '  ');
      expect(PdfSectionHelper.hasCertifications([emptyItem]), false);

      final validItem = CertificationModel(certificateName: 'AWS Certified');
      expect(PdfSectionHelper.hasCertifications([emptyItem, validItem]), true);
      expect(PdfSectionHelper.validCertifications([emptyItem, validItem]).length, 1);
    });

    test('hasLanguages and validLanguages handle empty and valid data', () {
      expect(PdfSectionHelper.hasLanguages(null), false);
      final emptyItem = LanguageModel(language: '  ');
      expect(PdfSectionHelper.hasLanguages([emptyItem]), false);

      final validItem = LanguageModel(language: 'English');
      expect(PdfSectionHelper.hasLanguages([emptyItem, validItem]), true);
      expect(PdfSectionHelper.validLanguages([emptyItem, validItem]).length, 1);
    });
  });
}
