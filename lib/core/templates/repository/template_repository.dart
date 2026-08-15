import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart';

class TemplateRepository {
  static final List<ResumeTemplate> _templates = [
    const ResumeTemplate(
      id: 'ats',
      name: 'ATS Friendly',
      description:
          'Compact, single-column design optimized for ATS parsing systems.',
      category: TemplateCategory.ats,
      thumbnail: 'assets/templates/previews/ats.png',
      previewAsset: 'assets/templates/previews/ats.png',
      atsRating: 5,
      accentColor: Colors.black,
      isDefault: true,
      requiresProfileImage: false,
    ),
    const ResumeTemplate(
      id: 'modern',
      name: 'Modern Clean',
      description:
          'Clean modern layout with subtle borders and clear section hierarchy.',
      category: TemplateCategory.professional,
      thumbnail: 'assets/templates/previews/modern.png',
      previewAsset: 'assets/templates/previews/modern.png',
      atsRating: 5,
      accentColor: Colors.blueGrey,
      isDefault: false,
      requiresProfileImage: false,
    ),
    const ResumeTemplate(
      id: 'creative',
      name: 'Creative Bold',
      description:
          'Premium software developer layout featuring profile photo area and cyan accents.',
      category: TemplateCategory.professional,
      thumbnail: 'assets/templates/previews/creative.png',
      previewAsset: 'assets/templates/previews/creative.png',
      atsRating: 5,
      accentColor: Colors.lightBlue,
      isDefault: false,
      requiresProfileImage: true,
    ),
    const ResumeTemplate(
      id: 'executive',
      name: 'Executive Corporate',
      description:
          'Sophisticated leadership layout featuring photo header and skill tag chips.',
      category: TemplateCategory.executive,
      thumbnail: 'assets/templates/previews/executive.png',
      previewAsset: 'assets/templates/previews/executive.png',
      atsRating: 4,
      accentColor: Colors.amber,
      isDefault: false,
      requiresProfileImage: true,
    ),
    const ResumeTemplate(
      id: 'academic',
      name: 'Academic',
      description:
          'Structured layout emphasizing research fields, publications, and references.',
      category: TemplateCategory.academic,
      thumbnail: 'assets/templates/previews/academic.png',
      previewAsset: 'assets/templates/previews/academic.png',
      atsRating: 5,
      accentColor: Color(0xFF00199E),
      isDefault: false,
      requiresProfileImage: false,
    ),
    const ResumeTemplate(
      id: 'classic',
      name: 'Classic Standard',
      description: 'Traditional timeless template suitable for conservative industries.',
      category: TemplateCategory.professional,
      thumbnail: 'assets/templates/previews/classic.png',
      previewAsset: 'assets/templates/previews/classic.png',
      atsRating: 5,
      accentColor: Colors.indigo,
      isDefault: false,
      requiresProfileImage: false,
    ),
    const ResumeTemplate(
      id: 'compact',
      name: 'Compact Density',
      description: 'High-density layout ideal for fitting dense work histories onto one page.',
      category: TemplateCategory.ats,
      thumbnail: 'assets/templates/previews/compact.png',
      previewAsset: 'assets/templates/previews/compact.png',
      atsRating: 5,
      accentColor: Colors.teal,
      isDefault: false,
      requiresProfileImage: false,
    ),
    const ResumeTemplate(
      id: 'elegant',
      name: 'Elegant Serif',
      description: 'Polished editorial typography with refined spacing and emphasis.',
      category: TemplateCategory.executive,
      thumbnail: 'assets/templates/previews/elegant.png',
      previewAsset: 'assets/templates/previews/elegant.png',
      atsRating: 4,
      accentColor: Colors.deepPurple,
      isDefault: false,
      requiresProfileImage: false,
    ),
    const ResumeTemplate(
      id: 'minimal',
      name: 'Minimal Clean',
      description: 'Ultra-minimalist aesthetic focusing purely on clean content structure.',
      category: TemplateCategory.academic,
      thumbnail: 'assets/templates/previews/minimal.png',
      previewAsset: 'assets/templates/previews/minimal.png',
      atsRating: 5,
      accentColor: Colors.grey,
      isDefault: false,
      requiresProfileImage: false,
    ),
    const ResumeTemplate(
      id: 'simple',
      name: 'Simple Basic',
      description: 'Straightforward simple layout for quick professional resumes.',
      category: TemplateCategory.ats,
      thumbnail: 'assets/templates/previews/simple.png',
      previewAsset: 'assets/templates/previews/simple.png',
      atsRating: 5,
      accentColor: Colors.blueAccent,
      isDefault: false,
      requiresProfileImage: false,
    ),
  ];

  /// Returns the list of all templates.
  List<ResumeTemplate> getTemplates() => _templates;

  /// Finds a template by its unique ID, safely falling back to defaultTemplate if not found.
  ResumeTemplate getTemplate(String id) {
    return _templates.firstWhere(
      (t) => t.id == id,
      orElse: () {
        final cleanId = id.toLowerCase();
        return _templates.firstWhere(
          (t) => cleanId.contains(t.id) || t.id.contains(cleanId),
          orElse: defaultTemplate,
        );
      },
    );
  }

  /// Returns the default template (ATS Friendly).
  ResumeTemplate defaultTemplate() {
    return _templates.firstWhere((t) => t.isDefault, orElse: () => _templates.first);
  }

  /// Checks if a template ID exists in the registry.
  bool contains(String id) {
    return _templates.any((t) => t.id == id);
  }
}
