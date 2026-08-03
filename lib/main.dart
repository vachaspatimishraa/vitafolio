import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/app/app.dart';
import 'package:vitafolio/services/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize application resources (database, configuration, etc.)
    await AppInitializer.initialize();
  } catch (e, stackTrace) {
    debugPrint('App initialization warning: $e\n$stackTrace');
  }

  runApp(const ProviderScope(child: App()));
}
