import 'package:vitafolio/features/resume/domain/entities/certification.dart';
import 'package:vitafolio/features/resume/domain/entities/education.dart';
import 'package:vitafolio/features/resume/domain/entities/experience.dart';
import 'package:vitafolio/features/resume/domain/entities/language.dart';
import 'package:vitafolio/features/resume/domain/entities/personal_details.dart';
import 'package:vitafolio/features/resume/domain/entities/professional_summary.dart';
import 'package:vitafolio/features/resume/domain/entities/resume.dart';
import 'package:vitafolio/features/resume/domain/entities/skill.dart';
import 'package:vitafolio/features/resume/domain/repositories/resume_repository.dart';
import 'package:vitafolio/features/resume/domain/value_objects/resume_id.dart';
import 'package:vitafolio/features/resume/domain/value_objects/template_id.dart';

/// Use case that safely updates specific sections of a Resume while preserving all unspecified sections intact.
class UpdateResumeSection {
  final ResumeRepository _repository;

  const UpdateResumeSection(this._repository);

  Future<Resume> updatePersonalDetails(ResumeId id, PersonalDetails personalDetails) async {
    final existing = await _getExisting(id);
    final updated = existing.copyWith(
      personalDetails: personalDetails,
      updatedAt: DateTime.now(),
    );
    return _repository.updateResume(updated);
  }

  Future<Resume> updateSummary(ResumeId id, ProfessionalSummary summary) async {
    final existing = await _getExisting(id);
    final updated = existing.copyWith(
      summary: summary,
      updatedAt: DateTime.now(),
    );
    return _repository.updateResume(updated);
  }

  Future<Resume> updateExperiences(ResumeId id, List<Experience> experiences) async {
    final existing = await _getExisting(id);
    final updated = existing.copyWith(
      experiences: experiences,
      updatedAt: DateTime.now(),
    );
    return _repository.updateResume(updated);
  }

  Future<Resume> updateEducations(ResumeId id, List<Education> educations) async {
    final existing = await _getExisting(id);
    final updated = existing.copyWith(
      educations: educations,
      updatedAt: DateTime.now(),
    );
    return _repository.updateResume(updated);
  }

  Future<Resume> updateSkills(ResumeId id, List<Skill> skills) async {
    final existing = await _getExisting(id);
    final updated = existing.copyWith(
      skills: skills,
      updatedAt: DateTime.now(),
    );
    return _repository.updateResume(updated);
  }

  Future<Resume> updateCertifications(ResumeId id, List<Certification> certifications) async {
    final existing = await _getExisting(id);
    final updated = existing.copyWith(
      certifications: certifications,
      updatedAt: DateTime.now(),
    );
    return _repository.updateResume(updated);
  }

  Future<Resume> updateLanguages(ResumeId id, List<Language> languages) async {
    final existing = await _getExisting(id);
    final updated = existing.copyWith(
      languages: languages,
      updatedAt: DateTime.now(),
    );
    return _repository.updateResume(updated);
  }

  Future<Resume> updateSelectedTemplate(ResumeId id, TemplateId templateId) async {
    return _repository.saveSelectedTemplate(id, templateId);
  }

  Future<Resume> _getExisting(ResumeId id) async {
    final existing = await _repository.getResume(id);
    if (existing == null) {
      throw Exception('Resume not found for ID: ${id.value}');
    }
    return existing;
  }
}
