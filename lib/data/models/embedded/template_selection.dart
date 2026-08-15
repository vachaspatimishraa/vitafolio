import 'package:isar/isar.dart';

part 'template_selection.g.dart';

@embedded
class TemplateSelection {
  String? templateId;
  String? templateName;
  String? category;
  bool? isAtsFriendly;
  String? themeColor; // Stored as hex string
}
