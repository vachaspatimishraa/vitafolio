import 'package:flutter/material.dart';
import 'package:vitafolio/features/templates/renderers/template_renderer.dart';

class TemplateModel {
  final String id;
  final String name;
  final String category;
  final String thumbnail;
  final String previewImage;
  final Color themeColor;
  final bool isAtsFriendly;
  final TemplateRenderer renderer;

  const TemplateModel({
    required this.id,
    required this.name,
    required this.category,
    this.thumbnail = '',
    this.previewImage = '',
    required this.themeColor,
    required this.isAtsFriendly,
    required this.renderer,
  });
}
