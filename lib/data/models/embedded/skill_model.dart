import 'package:isar/isar.dart';

part 'skill_model.g.dart';

@embedded
class SkillModel {
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  String? name;
  String? category;

  SkillModel({
    this.name,
    this.category,
  });

  SkillModel copyWith({
    String? id,
    String? name,
    String? category,
  }) {
    final model = SkillModel(
      name: name ?? this.name,
      category: category ?? this.category,
    );
    model.id = id ?? this.id;
    return model;
  }
}
