import 'package:flutter/material.dart';
import 'section_title.dart';

class ResumeSection extends StatelessWidget {
  final String title;
  final Widget child;

  const ResumeSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(title: title),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}
