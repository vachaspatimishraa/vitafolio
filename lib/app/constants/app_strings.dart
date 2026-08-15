import 'package:flutter/material.dart';

@immutable
abstract final class AppStrings {
  // App General
  static const String appName = 'Vitafolio';
  static const String appTagline = 'Build Your Professional Story';

  // Greeting / Dashboard
  static const String goodMorning = 'Good Morning';
  static const String goodAfternoon = 'Good Afternoon';
  static const String goodEvening = 'Good Evening';
  static const String greetingSubtitle = 'Build Your Professional Story';
  static const String searchResumes = 'Search resumes...';

  // Navigation / Titles
  static const String home = 'Home';
  static const String resume = 'Resume';
  static const String resumeEditor = 'Resume Editor';
  static const String templates = 'Templates';
  static const String preview = 'Preview';

  // Statistics
  static const String totalResumes = 'Total Resumes';
  static const String draftResumes = 'Draft Resumes';
  static const String completedResumes = 'Completed Resumes';
  static const String archivedResumes = 'Archived';

  // Sections
  static const String recentResumes = 'Recent Resumes';
  static const String noResumesYet = 'No Resumes Yet';

  // Buttons
  static const String createResume = 'Create Resume';
  static const String save = 'Save';
  static const String saveDraft = 'Save Draft';
  static const String previewResume = 'Preview Resume';
  static const String changeTemplate = 'Change Template';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String edit = 'Edit';
  static const String exportPdf = 'Export PDF';
  static const String sharePdf = 'Share PDF';
  static const String back = 'Back';
  static const String backToEditor = 'Back to Editor';
  static const String backToHome = 'Back to Home';
  static const String useTemplate = 'Use Template';
  static const String continueEditing = 'Continue Editing';
  static const String discard = 'Discard';
  static const String retry = 'Retry';

  // Labels & Hints
  static const String search = 'Search';
  static const String noResumesFound = 'No Resumes Found';

  // More Menu
  static const String open = 'Open';
  static const String duplicate = 'Duplicate';
  static const String rename = 'Rename';

  // Status
  static const String draft = 'Draft';
  static const String completed = 'Completed';
  static const String archived = 'Archived';

  // Filter & Sort
  static const String filterAll = 'All';
  static const String sortRecentlyUpdated = 'Recently Updated';
  static const String sortNewest = 'Newest';
  static const String sortOldest = 'Oldest';
  static const String sortAZ = 'A-Z';
  static const String sortZA = 'Z-A';

  // Dialogs
  static const String renameResume = 'Rename Resume';
  static const String renameHint = 'Enter a new name for your resume';
  static const String resumeName = 'Resume Name';
  static const String deleteResumeTitle = 'Delete Resume?';
  static const String deleteResumeMessage =
      'This action cannot be undone. Are you sure you want to delete this resume?';
  static const String resumeDeleted = 'Resume deleted successfully';
  static const String resumeRenamed = 'Resume renamed successfully';
  static const String resumeDuplicated = 'Resume duplicated successfully';

  // Error States
  static const String somethingWentWrong = 'Something went wrong';
  static const String failedToLoadResumes = 'Failed to load resumes';

  // Empty State
  static const String emptyTitle = 'No Resumes Yet';
  static const String emptyDescription =
      'Create your first professional resume in just a few minutes.';

  // Resume Sections
  static const String addExperience = 'Add Experience';
  static const String addEducation = 'Add Education';
  static const String addProject = 'Add Project';
  static const String addCertification = 'Add Certification';
  static const String addLanguage = 'Add Language';
  static const String addSkill = 'Add Skill';
  static const String projects = 'Projects';
  static const String languages = 'Languages';
  static const String certifications = 'Certifications';
}
