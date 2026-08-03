import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vitafolio/features/preview/widgets/preview_action_bar.dart';
import 'package:vitafolio/features/preview/widgets/preview_app_bar.dart';
import 'package:vitafolio/features/preview/widgets/resume_canvas.dart';
import 'package:vitafolio/features/preview/widgets/template_selector.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const PreviewAppBar(),
      bottomNavigationBar: const PreviewActionBar(),
      body: SafeArea(
        child: Column(
          children: [
            const TemplateSelector(),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ResumeCanvas(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
