import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vitafolio/features/home/view/home_screen.dart';
import 'package:vitafolio/features/preview/view/preview_screen.dart';
import 'package:vitafolio/features/splash/view/splash_screen.dart';

import 'package:vitafolio/features/template_selection/presentation/pages/template_selection_page.dart';
import 'package:vitafolio/features/personal_details/presentation/pages/personal_details_page.dart';
import 'package:vitafolio/features/profile_image/presentation/pages/profile_image_page.dart';
import 'package:vitafolio/features/professional_summary/presentation/pages/professional_summary_page.dart';
import 'package:vitafolio/features/experience/presentation/pages/experience_list_page.dart';
import 'package:vitafolio/features/experience/presentation/pages/add_experience_page.dart';
import 'package:vitafolio/features/projects/presentation/pages/projects_page.dart';
import 'package:vitafolio/features/projects/presentation/pages/add_project_page.dart';
import 'package:vitafolio/features/education/presentation/pages/education_list_page.dart';
import 'package:vitafolio/features/education/presentation/pages/add_education_page.dart';
import 'package:vitafolio/features/skills/presentation/pages/skills_page.dart';
import 'package:vitafolio/features/certifications/presentation/pages/certifications_page.dart';
import 'package:vitafolio/features/certifications/presentation/pages/add_certification_page.dart';
import 'package:vitafolio/features/languages/presentation/pages/languages_page.dart';
import 'package:vitafolio/features/languages/presentation/pages/add_language_page.dart';

import 'package:vitafolio/features/experience/presentation/viewmodels/experience_viewmodel.dart';
import 'package:vitafolio/features/education/presentation/viewmodels/education_viewmodel.dart';
import 'package:vitafolio/features/certifications/presentation/viewmodels/certifications_viewmodel.dart';
import 'package:vitafolio/features/languages/presentation/viewmodels/languages_viewmodel.dart';
import 'package:vitafolio/features/resume/domain/entities/project.dart';
import 'package:vitafolio/features/review_resume/presentation/pages/review_resume_page.dart';
import 'package:vitafolio/features/upload/view/upload_resume_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const upload = '/upload';
  static const personal = '/personal';
  static const profileImage = '/profile-image';
  static const summary = '/summary';
  static const experience = '/experience';
  static const addExperience = '/add-experience';
  static const projects = '/projects';
  static const addProject = '/add-project';
  static const education = '/education';
  static const addEducation = '/add-education';
  static const skills = '/skills';
  static const certifications = '/certifications';
  static const addCertification = '/add-certification';
  static const languages = '/languages';
  static const addLanguage = '/add-language';
  static const preview = '/preview';
  static const review = '/review';
  static const templates = '/templates';
  static const templatePreview = 'template_preview';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              'The page "${state.uri}" could not be found or loaded.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    ),
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.upload,
        name: 'upload',
        builder: (context, state) => const UploadResumeScreen(),
      ),
      GoRoute(
        path: AppRoutes.personal,
        name: 'personal',
        builder: (context, state) => const PersonalDetailsPage(),
      ),
      GoRoute(
        path: AppRoutes.profileImage,
        name: 'profile_image',
        builder: (context, state) => const ProfileImagePage(),
      ),
      GoRoute(
        path: AppRoutes.summary,
        name: 'summary',
        builder: (context, state) => const ProfessionalSummaryPage(),
      ),
      GoRoute(
        path: AppRoutes.experience,
        name: 'experience',
        builder: (context, state) => const ExperienceListPage(),
      ),
      GoRoute(
        path: AppRoutes.addExperience,
        name: 'add_experience',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isEditing = extra?['isEditing'] as bool? ?? false;
          final item = extra?['item'] as MockExperienceItem?;
          return AddExperiencePage(isEditing: isEditing, initialItem: item);
        },
      ),
      GoRoute(
        path: AppRoutes.projects,
        name: 'projects',
        builder: (context, state) => const ProjectsPage(),
      ),
      GoRoute(
        path: AppRoutes.addProject,
        name: 'add_project',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isEditing = extra?['isEditing'] as bool? ?? false;
          final project = extra?['project'] as Project?;
          return AddProjectPage(
            isEditing: isEditing,
            initialProject: project,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.education,
        name: 'education',
        builder: (context, state) => const EducationListPage(),
      ),
      GoRoute(
        path: AppRoutes.addEducation,
        name: 'add_education',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isEditing = extra?['isEditing'] as bool? ?? false;
          final item = extra?['item'] as MockEducationItem?;
          return AddEducationPage(isEditing: isEditing, initialItem: item);
        },
      ),
      GoRoute(
        path: AppRoutes.skills,
        name: 'skills',
        builder: (context, state) => const SkillsPage(),
      ),
      GoRoute(
        path: AppRoutes.certifications,
        name: 'certifications',
        builder: (context, state) => const CertificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.addCertification,
        name: 'add_certification',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isEditing = extra?['isEditing'] as bool? ?? false;
          final item = extra?['item'] as MockCertificationItem?;
          return AddCertificationPage(isEditing: isEditing, initialItem: item);
        },
      ),
      GoRoute(
        path: AppRoutes.languages,
        name: 'languages',
        builder: (context, state) => const LanguagesPage(),
      ),
      GoRoute(
        path: AppRoutes.addLanguage,
        name: 'add_language',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final isEditing = extra?['isEditing'] as bool? ?? false;
          final item = extra?['item'] as MockLanguageItem?;
          return AddLanguagePage(isEditing: isEditing, initialLanguage: item);
        },
      ),
      GoRoute(
        path: AppRoutes.templates,
        name: 'templates',
        builder: (context, state) => const TemplateSelectionPage(),
      ),
      GoRoute(
        path: AppRoutes.preview,
        name: 'preview',
        builder: (context, state) => const PreviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.review,
        name: 'review',
        builder: (context, state) => const ReviewResumePage(),
      ),
    ],
  );
}

