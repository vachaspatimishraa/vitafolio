import 'package:isar/isar.dart';

part 'certification_model.g.dart';

@embedded
class CertificationModel {
  String id = DateTime.now().microsecondsSinceEpoch.toString();
  String? certificateName;
  String? organization;
  DateTime? issueDate;
  String? credentialUrl;

  CertificationModel({
    this.certificateName,
    this.organization,
    this.issueDate,
    this.credentialUrl,
  });

  CertificationModel copyWith({
    String? id,
    String? certificateName,
    String? organization,
    DateTime? issueDate,
    String? credentialUrl,
  }) {
    final model = CertificationModel(
      certificateName: certificateName ?? this.certificateName,
      organization: organization ?? this.organization,
      issueDate: issueDate ?? this.issueDate,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
    model.id = id ?? this.id;
    return model;
  }
}
