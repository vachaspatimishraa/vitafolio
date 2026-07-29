import 'package:isar/isar.dart';

part 'skill_model.g.dart';

@embedded
class SkillModel {
  String? id;
  String? name;
  String? category;

  SkillModel({this.id, this.name, this.category});

  SkillModel copyWith({String? id, String? name, String? category}) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
    );
  }
}
