import 'package:flutter/material.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../shared/widgets/cards/app_card.dart';
import 'section_header.dart';

class EditorSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const EditorSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, trailing: trailing),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}
