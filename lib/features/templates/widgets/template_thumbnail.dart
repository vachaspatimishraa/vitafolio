import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart' as core;

class TemplateThumbnail extends StatelessWidget {
  final core.ResumeTemplate template;
  final String heroTag;

  const TemplateThumbnail({
    super.key,
    required this.template,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: IgnorePointer(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: 380,
              height: 537,
              child: Image.asset(
                template.previewAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.description_outlined, size: 48),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
