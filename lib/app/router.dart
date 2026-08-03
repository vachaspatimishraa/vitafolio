import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vitafolio/features/editor/view/editor_screen.dart';
import 'package:vitafolio/features/home/view/home_screen.dart';
import 'package:vitafolio/features/preview/view/preview_screen.dart';
import 'package:vitafolio/features/splash/view/splash_screen.dart';
import 'package:vitafolio/features/templates/view/templates_screen.dart';
import 'package:vitafolio/features/templates/view/template_preview_screen.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart' as core;

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const editor = '/editor';
  static const preview = '/preview';
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
        path: AppRoutes.templates,
        name: 'templates',
        builder: (context, state) => const TemplatesScreen(),
        routes: [
          GoRoute(
            path: 'preview',
            name: 'template_preview',
            builder: (context, state) {
              final template = state.extra;
              if (template is core.ResumeTemplate) {
                return TemplatePreviewScreen(template: template);
              }
              return Scaffold(
                appBar: AppBar(title: const Text('Template Preview')),
                body: const Center(
                  child: Text('Invalid or missing template data.'),
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.editor,
        name: 'editor',
        builder: (context, state) => const EditorScreen(),
      ),
      GoRoute(
        path: AppRoutes.preview,
        name: 'preview',
        builder: (context, state) => const PreviewScreen(),
      ),
    ],
  );
}
