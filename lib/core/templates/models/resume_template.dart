import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/renderers/template_renderer.dart';
import 'package:vitafolio/core/templates/themes/template_theme.dart';

enum TemplateCategory { ats, professional, executive, academic }

extension TemplateCategoryExtension on TemplateCategory {
  String get label {
    switch (this) {
      case TemplateCategory.ats:
        return 'ATS';
      case TemplateCategory.professional:
        return 'Professional';
      case TemplateCategory.executive:
        return 'Executive';
      case TemplateCategory.academic:
        return 'Academic';
    }
  }
}

class ResumeTemplate {
  final String id;
  final String name;
  final String description;
  final TemplateCategory category;
  final String thumbnail;
  final String previewAsset;
  final int atsRating;
  final Color accentColor;
  final bool isDefault;
  final ResumeTemplateRenderer? renderer;
  final ResumeTheme? theme;
  final bool requiresProfileImage;

  const ResumeTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.previewAsset,
    required this.atsRating,
    required this.accentColor,
    required this.isDefault,
    this.renderer,
    this.theme,
    this.requiresProfileImage = false,
  });
}
