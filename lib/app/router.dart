import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/editor/view/editor_screen.dart';
import '../features/home/view/home_screen.dart';
import '../features/navigation/view/app_shell.dart';
import '../features/preview/view/preview_screen.dart';
import '../features/splash/view/splash_screen.dart';
import '../features/templates/view/templates_screen.dart';
import '../features/templates/view/template_preview_screen.dart';
import '../features/templates/models/template_model.dart';

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
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Text('The requested page "${state.uri}" could not be found.'),
      ),
    ),
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.templates,
                name: 'templates',
                builder: (context, state) => const TemplatesScreen(),
                routes: [
                  GoRoute(
                    path: 'preview',
                    name: 'template_preview',
                    builder: (context, state) {
                      final template = state.extra as TemplateModel;
                      return TemplatePreviewScreen(template: template);
                    },
                  ),
                ],
              ),
            ],
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
