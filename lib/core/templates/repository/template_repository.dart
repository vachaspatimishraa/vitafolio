import 'package:flutter/material.dart';
import 'package:vitafolio/core/templates/models/resume_template.dart';
import 'package:vitafolio/core/templates/ats_professional/ats_pdf_renderer.dart';
import 'package:vitafolio/core/templates/ats_professional/ats_theme.dart';
import 'package:vitafolio/core/templates/professional_modern/modern_pdf_renderer.dart';
import 'package:vitafolio/core/templates/professional_modern/modern_theme.dart';
import 'package:vitafolio/core/templates/awesome_professional/awesome_pdf_renderer.dart';
import 'package:vitafolio/core/templates/awesome_professional/awesome_theme.dart';
import 'package:vitafolio/core/templates/modern_executive/executive_pdf_renderer.dart';
import 'package:vitafolio/core/templates/modern_executive/executive_theme.dart';
import 'package:vitafolio/core/templates/academic_blue/academic_pdf_renderer.dart';
import 'package:vitafolio/core/templates/academic_blue/academic_theme.dart';

class TemplateRepository {
  static final List<ResumeTemplate> _templates = [
    ResumeTemplate(
      id: 'ats_professional',
      name: 'ATS Professional',
      description:
          'Compact, black & white, single-column design optimized for ATS parsing systems.',
      category: TemplateCategory.ats,
      thumbnail: 'assets/templates/thumbnails/ats.png',
      atsRating: 5,
      accentColor: Colors.black,
      isDefault: true,
      renderer: AtsPdfRenderer(),
      theme: atsTheme,
    ),
    ResumeTemplate(
      id: 'professional_modern',
      name: 'Professional Modern',
      description:
          'Clean modern layout with subtle borders and clear section hierarchy.',
      category: TemplateCategory.professional,
      thumbnail: 'assets/templates/thumbnails/modern.png',
      atsRating: 5,
      accentColor: Colors.blueGrey,
      isDefault: false,
      renderer: ModernPdfRenderer(),
      theme: modernTheme,
    ),
    ResumeTemplate(
      id: 'awesome_professional',
      name: 'Awesome Professional',
      description:
          'Premium software developer layout featuring elegant cyan highlights.',
      category: TemplateCategory.professional,
      thumbnail: 'assets/templates/thumbnails/creative.png',
      atsRating: 5,
      accentColor: Colors.lightBlue,
      isDefault: false,
      renderer: AwesomePdfRenderer(),
      theme: awesomeTheme,
    ),
    ResumeTemplate(
      id: 'modern_executive',
      name: 'Modern Executive',
      description:
          'Sophisticated style designed for leadership roles, featuring skill tag chips.',
      category: TemplateCategory.executive,
      thumbnail: 'assets/templates/thumbnails/executive.png',
      atsRating: 4,
      accentColor: Colors.amber,
      isDefault: false,
      renderer: ExecutivePdfRenderer(),
      theme: executiveTheme,
    ),
    ResumeTemplate(
      id: 'academic_blue',
      name: 'Academic Blue',
      description:
          'Structured layout emphasizing research fields, publications, and references.',
      category: TemplateCategory.academic,
      thumbnail: 'assets/templates/thumbnails/minimal.png',
      atsRating: 5,
      accentColor: Color(0xFF00199E),
      isDefault: false,
      renderer: AcademicPdfRenderer(),
      theme: academicTheme,
    ),
  ];

  /// Returns the list of all templates.
  List<ResumeTemplate> getTemplates() => _templates;

  /// Finds a template by its unique ID, falling back to the default if not found.
  ResumeTemplate getTemplate(String id) {
    return _templates.firstWhere(
      (t) => t.id == id,
      orElse: defaultTemplate,
    );
  }

  /// Returns the default template.
  ResumeTemplate defaultTemplate() {
    return _templates.firstWhere((t) => t.isDefault);
  }
}
