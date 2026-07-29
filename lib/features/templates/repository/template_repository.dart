import 'package:flutter/material.dart';
import '../models/template_model.dart';
import '../renderers/modern_template.dart';
import '../renderers/ats_template.dart';
import '../renderers/minimal_template.dart';
import '../renderers/executive_template.dart';
import '../renderers/creative_template.dart';

class TemplateRepository {
  static const List<TemplateModel> templates = [
    TemplateModel(
      id: 'modern_clean',
      name: 'Modern Clean',
      category: 'Modern',
      thumbnail: 'assets/templates/thumbnails/modern.png',
      previewImage: 'assets/templates/previews/modern.png',
      themeColor: Colors.blue,
      isAtsFriendly: true,
      renderer: ModernTemplateRenderer(),
    ),
    TemplateModel(
      id: 'ats_professional',
      name: 'ATS Professional',
      category: 'ATS Friendly',
      thumbnail: 'assets/templates/thumbnails/ats.png',
      previewImage: 'assets/templates/previews/ats.png',
      themeColor: Colors.black,
      isAtsFriendly: true,
      renderer: AtsTemplateRenderer(),
    ),
    TemplateModel(
      id: 'minimal_elegant',
      name: 'Minimal Elegant',
      category: 'Minimal',
      thumbnail: 'assets/templates/thumbnails/minimal.png',
      previewImage: 'assets/templates/previews/minimal.png',
      themeColor: Colors.grey,
      isAtsFriendly: true,
      renderer: MinimalTemplateRenderer(),
    ),
    TemplateModel(
      id: 'executive_corp',
      name: 'Executive Corporate',
      category: 'Executive',
      thumbnail: 'assets/templates/thumbnails/executive.png',
      previewImage: 'assets/templates/previews/executive.png',
      themeColor: Colors.indigo,
      isAtsFriendly: false,
      renderer: ExecutiveTemplateRenderer(),
    ),
    TemplateModel(
      id: 'creative_bold',
      name: 'Creative Bold',
      category: 'Creative',
      thumbnail: 'assets/templates/thumbnails/creative.png',
      previewImage: 'assets/templates/previews/creative.png',
      themeColor: Colors.orange,
      isAtsFriendly: false,
      renderer: CreativeTemplateRenderer(),
    ),
  ];

  List<TemplateModel> getAllTemplates() => templates;

  TemplateModel? getTemplateById(String id) {
    try {
      return templates.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  List<TemplateModel> filterByCategory(String category) {
    if (category.toLowerCase() == 'all') return templates;
    return templates
        .where((t) => t.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  List<TemplateModel> searchTemplates(String query) {
    if (query.trim().isEmpty) return templates;
    final lowercaseQuery = query.toLowerCase();
    return templates.where((t) {
      return t.name.toLowerCase().contains(lowercaseQuery) ||
          t.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
