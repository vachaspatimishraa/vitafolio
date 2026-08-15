import 'package:isar/isar.dart';

part 'certification_model.g.dart';

@embedded
class CertificationModel {
  String? id;
  String? certificateName;
  String? organization;
  DateTime? issueDate;
  String? credentialUrl;

  CertificationModel({
    this.id,
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
    return CertificationModel(
      id: id ?? this.id,
      certificateName: certificateName ?? this.certificateName,
      organization: organization ?? this.organization,
      issueDate: issueDate ?? this.issueDate,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
  }
}
