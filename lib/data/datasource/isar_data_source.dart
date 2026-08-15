import 'package:isar/isar.dart';
import 'package:vitafolio/data/models/resume_model.dart';

/// Data source for accessing ResumeModel data in Isar database.
///
/// This class provides the lowest-level data access methods.
/// It should only be used by repository classes, not by ViewModels or UI.
class IsarDataSource {
  final Isar? _isar;

  /// Creates an [IsarDataSource] instance with the given Isar database.
  const IsarDataSource(this._isar);

  /// Saves a resume to the database.
  ///
  /// If the resume already exists (has an ID), it will be updated.
  /// Otherwise, a new resume will be created.
  Future<void> saveResume(ResumeModel resume) async {
    final db = _isar;
    if (db == null) return;
    await db.writeTxn(() async {
      await db.resumeModels.put(resume);
    });
  }

  /// Retrieves a resume by its ID.
  ///
  /// Returns `null` if no resume with the given ID exists.
  Future<ResumeModel?> getResume(int id) async {
    final db = _isar;
    if (db == null) return null;
    return db.resumeModels.get(id);
  }

  /// Retrieves all resumes from the database.
  Future<List<ResumeModel>> getAllResumes() async {
    final db = _isar;
    if (db == null) return [];
    return db.resumeModels.where().findAll();
  }

  /// Deletes a resume by its ID.
  Future<void> deleteResume(int id) async {
    final db = _isar;
    if (db == null) return;
    await db.writeTxn(() async {
      await db.resumeModels.delete(id);
    });
  }

  /// Searches resumes by name.
  ///
  /// The search is case-insensitive and looks for partial matches.
  /// Returns all resumes if the query is empty.
  Future<List<ResumeModel>> searchResumes(String query) async {
    final db = _isar;
    if (db == null) return [];
    if (query.isEmpty) {
      return getAllResumes();
    }
    final lowerQuery = query.toLowerCase();
    return db.resumeModels
        .filter()
        .resumeNameContains(lowerQuery, caseSensitive: false)
        .findAll();
  }

  /// Updates a resume's selected template.
  Future<void> updateResumeTemplate(
    int resumeId,
    String templateId,
    String templateName,
  ) async {
    final db = _isar;
    if (db == null) return;
    await db.writeTxn(() async {
      final resume = await db.resumeModels.get(resumeId);
      if (resume != null) {
        resume.selectedTemplate?.templateId = templateId;
        resume.selectedTemplate?.templateName = templateName;
        resume.lastUpdated = DateTime.now();
        await db.resumeModels.put(resume);
      }
    });
  }
}
