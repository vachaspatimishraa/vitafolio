// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetResumeModelCollection on Isar {
  IsarCollection<ResumeModel> get resumeModels => this.collection();
}

const ResumeModelSchema = CollectionSchema(
  name: r'ResumeModel',
  id: -6006429952463362210,
  properties: {
    r'certifications': PropertySchema(
      id: 0,
      name: r'certifications',
      type: IsarType.objectList,
      target: r'CertificationModel',
    ),
    r'createdDate': PropertySchema(
      id: 1,
      name: r'createdDate',
      type: IsarType.dateTime,
    ),
    r'education': PropertySchema(
      id: 2,
      name: r'education',
      type: IsarType.objectList,
      target: r'EducationModel',
    ),
    r'experience': PropertySchema(
      id: 3,
      name: r'experience',
      type: IsarType.objectList,
      target: r'ExperienceModel',
    ),
    r'languages': PropertySchema(
      id: 4,
      name: r'languages',
      type: IsarType.objectList,
      target: r'LanguageModel',
    ),
    r'lastUpdated': PropertySchema(
      id: 5,
      name: r'lastUpdated',
      type: IsarType.dateTime,
    ),
    r'personalInfo': PropertySchema(
      id: 6,
      name: r'personalInfo',
      type: IsarType.object,
      target: r'PersonalInformation',
    ),
    r'professionalSummary': PropertySchema(
      id: 7,
      name: r'professionalSummary',
      type: IsarType.object,
      target: r'ProfessionalSummary',
    ),
    r'projects': PropertySchema(
      id: 8,
      name: r'projects',
      type: IsarType.objectList,
      target: r'ProjectModel',
    ),
    r'resumeName': PropertySchema(
      id: 9,
      name: r'resumeName',
      type: IsarType.string,
    ),
    r'selectedTemplate': PropertySchema(
      id: 10,
      name: r'selectedTemplate',
      type: IsarType.object,
      target: r'TemplateSelection',
    ),
    r'skills': PropertySchema(
      id: 11,
      name: r'skills',
      type: IsarType.objectList,
      target: r'SkillModel',
    ),
    r'status': PropertySchema(
      id: 12,
      name: r'status',
      type: IsarType.byte,
      enumMap: _ResumeModelstatusEnumValueMap,
    )
  },
  estimateSize: _resumeModelEstimateSize,
  serialize: _resumeModelSerialize,
  deserialize: _resumeModelDeserialize,
  deserializeProp: _resumeModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'resumeName': IndexSchema(
      id: 3434071430059631215,
      name: r'resumeName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'resumeName',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'createdDate': IndexSchema(
      id: 7275501510556639048,
      name: r'createdDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'lastUpdated': IndexSchema(
      id: 8989359681631629925,
      name: r'lastUpdated',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastUpdated',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'TemplateSelection': TemplateSelectionSchema,
    r'PersonalInformation': PersonalInformationSchema,
    r'ProfessionalSummary': ProfessionalSummarySchema,
    r'EducationModel': EducationModelSchema,
    r'ExperienceModel': ExperienceModelSchema,
    r'SkillModel': SkillModelSchema,
    r'ProjectModel': ProjectModelSchema,
    r'CertificationModel': CertificationModelSchema,
    r'LanguageModel': LanguageModelSchema
  },
  getId: _resumeModelGetId,
  getLinks: _resumeModelGetLinks,
  attach: _resumeModelAttach,
  version: '3.1.0+1',
);

int _resumeModelEstimateSize(
  ResumeModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.certifications;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[CertificationModel]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              CertificationModelSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.education;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[EducationModel]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              EducationModelSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.experience;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ExperienceModel]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              ExperienceModelSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final list = object.languages;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[LanguageModel]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              LanguageModelSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.personalInfo;
    if (value != null) {
      bytesCount += 3 +
          PersonalInformationSchema.estimateSize(
              value, allOffsets[PersonalInformation]!, allOffsets);
    }
  }
  {
    final value = object.professionalSummary;
    if (value != null) {
      bytesCount += 3 +
          ProfessionalSummarySchema.estimateSize(
              value, allOffsets[ProfessionalSummary]!, allOffsets);
    }
  }
  {
    final list = object.projects;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[ProjectModel]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              ProjectModelSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  {
    final value = object.resumeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.selectedTemplate;
    if (value != null) {
      bytesCount += 3 +
          TemplateSelectionSchema.estimateSize(
              value, allOffsets[TemplateSelection]!, allOffsets);
    }
  }
  {
    final list = object.skills;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[SkillModel]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              SkillModelSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  return bytesCount;
}

void _resumeModelSerialize(
  ResumeModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<CertificationModel>(
    offsets[0],
    allOffsets,
    CertificationModelSchema.serialize,
    object.certifications,
  );
  writer.writeDateTime(offsets[1], object.createdDate);
  writer.writeObjectList<EducationModel>(
    offsets[2],
    allOffsets,
    EducationModelSchema.serialize,
    object.education,
  );
  writer.writeObjectList<ExperienceModel>(
    offsets[3],
    allOffsets,
    ExperienceModelSchema.serialize,
    object.experience,
  );
  writer.writeObjectList<LanguageModel>(
    offsets[4],
    allOffsets,
    LanguageModelSchema.serialize,
    object.languages,
  );
  writer.writeDateTime(offsets[5], object.lastUpdated);
  writer.writeObject<PersonalInformation>(
    offsets[6],
    allOffsets,
    PersonalInformationSchema.serialize,
    object.personalInfo,
  );
  writer.writeObject<ProfessionalSummary>(
    offsets[7],
    allOffsets,
    ProfessionalSummarySchema.serialize,
    object.professionalSummary,
  );
  writer.writeObjectList<ProjectModel>(
    offsets[8],
    allOffsets,
    ProjectModelSchema.serialize,
    object.projects,
  );
  writer.writeString(offsets[9], object.resumeName);
  writer.writeObject<TemplateSelection>(
    offsets[10],
    allOffsets,
    TemplateSelectionSchema.serialize,
    object.selectedTemplate,
  );
  writer.writeObjectList<SkillModel>(
    offsets[11],
    allOffsets,
    SkillModelSchema.serialize,
    object.skills,
  );
  writer.writeByte(offsets[12], object.status.index);
}

ResumeModel _resumeModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ResumeModel(
    certifications: reader.readObjectList<CertificationModel>(
      offsets[0],
      CertificationModelSchema.deserialize,
      allOffsets,
      CertificationModel(),
    ),
    createdDate: reader.readDateTimeOrNull(offsets[1]),
    education: reader.readObjectList<EducationModel>(
      offsets[2],
      EducationModelSchema.deserialize,
      allOffsets,
      EducationModel(),
    ),
    experience: reader.readObjectList<ExperienceModel>(
      offsets[3],
      ExperienceModelSchema.deserialize,
      allOffsets,
      ExperienceModel(),
    ),
    id: id,
    languages: reader.readObjectList<LanguageModel>(
      offsets[4],
      LanguageModelSchema.deserialize,
      allOffsets,
      LanguageModel(),
    ),
    lastUpdated: reader.readDateTimeOrNull(offsets[5]),
    personalInfo: reader.readObjectOrNull<PersonalInformation>(
      offsets[6],
      PersonalInformationSchema.deserialize,
      allOffsets,
    ),
    professionalSummary: reader.readObjectOrNull<ProfessionalSummary>(
      offsets[7],
      ProfessionalSummarySchema.deserialize,
      allOffsets,
    ),
    projects: reader.readObjectList<ProjectModel>(
      offsets[8],
      ProjectModelSchema.deserialize,
      allOffsets,
      ProjectModel(),
    ),
    resumeName: reader.readStringOrNull(offsets[9]),
    selectedTemplate: reader.readObjectOrNull<TemplateSelection>(
      offsets[10],
      TemplateSelectionSchema.deserialize,
      allOffsets,
    ),
    skills: reader.readObjectList<SkillModel>(
      offsets[11],
      SkillModelSchema.deserialize,
      allOffsets,
      SkillModel(),
    ),
    status:
        _ResumeModelstatusValueEnumMap[reader.readByteOrNull(offsets[12])] ??
            ResumeStatus.draft,
  );
  return object;
}

P _resumeModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<CertificationModel>(
        offset,
        CertificationModelSchema.deserialize,
        allOffsets,
        CertificationModel(),
      )) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readObjectList<EducationModel>(
        offset,
        EducationModelSchema.deserialize,
        allOffsets,
        EducationModel(),
      )) as P;
    case 3:
      return (reader.readObjectList<ExperienceModel>(
        offset,
        ExperienceModelSchema.deserialize,
        allOffsets,
        ExperienceModel(),
      )) as P;
    case 4:
      return (reader.readObjectList<LanguageModel>(
        offset,
        LanguageModelSchema.deserialize,
        allOffsets,
        LanguageModel(),
      )) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readObjectOrNull<PersonalInformation>(
        offset,
        PersonalInformationSchema.deserialize,
        allOffsets,
      )) as P;
    case 7:
      return (reader.readObjectOrNull<ProfessionalSummary>(
        offset,
        ProfessionalSummarySchema.deserialize,
        allOffsets,
      )) as P;
    case 8:
      return (reader.readObjectList<ProjectModel>(
        offset,
        ProjectModelSchema.deserialize,
        allOffsets,
        ProjectModel(),
      )) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readObjectOrNull<TemplateSelection>(
        offset,
        TemplateSelectionSchema.deserialize,
        allOffsets,
      )) as P;
    case 11:
      return (reader.readObjectList<SkillModel>(
        offset,
        SkillModelSchema.deserialize,
        allOffsets,
        SkillModel(),
      )) as P;
    case 12:
      return (_ResumeModelstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          ResumeStatus.draft) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ResumeModelstatusEnumValueMap = {
  'draft': 0,
  'completed': 1,
  'archived': 2,
};
const _ResumeModelstatusValueEnumMap = {
  0: ResumeStatus.draft,
  1: ResumeStatus.completed,
  2: ResumeStatus.archived,
};

Id _resumeModelGetId(ResumeModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _resumeModelGetLinks(ResumeModel object) {
  return [];
}

void _resumeModelAttach(
    IsarCollection<dynamic> col, Id id, ResumeModel object) {
  object.id = id;
}

extension ResumeModelQueryWhereSort
    on QueryBuilder<ResumeModel, ResumeModel, QWhere> {
  QueryBuilder<ResumeModel, ResumeModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhere> anyResumeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'resumeName'),
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhere> anyCreatedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdDate'),
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhere> anyLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastUpdated'),
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhere> anyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'status'),
      );
    });
  }
}

extension ResumeModelQueryWhere
    on QueryBuilder<ResumeModel, ResumeModel, QWhereClause> {
  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> resumeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'resumeName',
        value: [null],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      resumeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'resumeName',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> resumeNameEqualTo(
      String? resumeName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'resumeName',
        value: [resumeName],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      resumeNameNotEqualTo(String? resumeName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'resumeName',
              lower: [],
              upper: [resumeName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'resumeName',
              lower: [resumeName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'resumeName',
              lower: [resumeName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'resumeName',
              lower: [],
              upper: [resumeName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      resumeNameGreaterThan(
    String? resumeName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'resumeName',
        lower: [resumeName],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> resumeNameLessThan(
    String? resumeName, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'resumeName',
        lower: [],
        upper: [resumeName],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> resumeNameBetween(
    String? lowerResumeName,
    String? upperResumeName, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'resumeName',
        lower: [lowerResumeName],
        includeLower: includeLower,
        upper: [upperResumeName],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      resumeNameStartsWith(String ResumeNamePrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'resumeName',
        lower: [ResumeNamePrefix],
        upper: ['$ResumeNamePrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      resumeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'resumeName',
        value: [''],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      resumeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'resumeName',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'resumeName',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'resumeName',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'resumeName',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      createdDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdDate',
        value: [null],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      createdDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdDate',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> createdDateEqualTo(
      DateTime? createdDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdDate',
        value: [createdDate],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      createdDateNotEqualTo(DateTime? createdDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdDate',
              lower: [],
              upper: [createdDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdDate',
              lower: [createdDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdDate',
              lower: [createdDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdDate',
              lower: [],
              upper: [createdDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      createdDateGreaterThan(
    DateTime? createdDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdDate',
        lower: [createdDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> createdDateLessThan(
    DateTime? createdDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdDate',
        lower: [],
        upper: [createdDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> createdDateBetween(
    DateTime? lowerCreatedDate,
    DateTime? upperCreatedDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdDate',
        lower: [lowerCreatedDate],
        includeLower: includeLower,
        upper: [upperCreatedDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      lastUpdatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastUpdated',
        value: [null],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      lastUpdatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> lastUpdatedEqualTo(
      DateTime? lastUpdated) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastUpdated',
        value: [lastUpdated],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      lastUpdatedNotEqualTo(DateTime? lastUpdated) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [],
              upper: [lastUpdated],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [lastUpdated],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [lastUpdated],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastUpdated',
              lower: [],
              upper: [lastUpdated],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause>
      lastUpdatedGreaterThan(
    DateTime? lastUpdated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [lastUpdated],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> lastUpdatedLessThan(
    DateTime? lastUpdated, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [],
        upper: [lastUpdated],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> lastUpdatedBetween(
    DateTime? lowerLastUpdated,
    DateTime? upperLastUpdated, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastUpdated',
        lower: [lowerLastUpdated],
        includeLower: includeLower,
        upper: [upperLastUpdated],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> statusEqualTo(
      ResumeStatus status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> statusNotEqualTo(
      ResumeStatus status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> statusGreaterThan(
    ResumeStatus status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [status],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> statusLessThan(
    ResumeStatus status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [],
        upper: [status],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterWhereClause> statusBetween(
    ResumeStatus lowerStatus,
    ResumeStatus upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [lowerStatus],
        includeLower: includeLower,
        upper: [upperStatus],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ResumeModelQueryFilter
    on QueryBuilder<ResumeModel, ResumeModel, QFilterCondition> {
  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'certifications',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'certifications',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'certifications',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'certifications',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'certifications',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'certifications',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'certifications',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'certifications',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      createdDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdDate',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      createdDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdDate',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      createdDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      createdDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      createdDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      createdDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'education',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'education',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'education',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'education',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'education',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'education',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'education',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'education',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'experience',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'experience',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experience',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experience',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experience',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experience',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experience',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'experience',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'languages',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'languages',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languages',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languages',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languages',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languages',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languages',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'languages',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      lastUpdatedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUpdated',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      lastUpdatedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUpdated',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      lastUpdatedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      lastUpdatedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      lastUpdatedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUpdated',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      lastUpdatedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUpdated',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      personalInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'personalInfo',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      personalInfoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'personalInfo',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      professionalSummaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'professionalSummary',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      professionalSummaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'professionalSummary',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      projectsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'projects',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      projectsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'projects',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      projectsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projects',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      projectsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projects',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      projectsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projects',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      projectsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projects',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      projectsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projects',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      projectsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'projects',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resumeName',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resumeName',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resumeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resumeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resumeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resumeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resumeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resumeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resumeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resumeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resumeName',
        value: '',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      resumeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resumeName',
        value: '',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      selectedTemplateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selectedTemplate',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      selectedTemplateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selectedTemplate',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> skillsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'skills',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      skillsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'skills',
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      skillsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'skills',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      skillsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'skills',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      skillsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'skills',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      skillsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'skills',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      skillsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'skills',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      skillsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'skills',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> statusEqualTo(
      ResumeStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      statusGreaterThan(
    ResumeStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> statusLessThan(
    ResumeStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> statusBetween(
    ResumeStatus lower,
    ResumeStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ResumeModelQueryObject
    on QueryBuilder<ResumeModel, ResumeModel, QFilterCondition> {
  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      certificationsElement(FilterQuery<CertificationModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'certifications');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      educationElement(FilterQuery<EducationModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'education');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      experienceElement(FilterQuery<ExperienceModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'experience');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      languagesElement(FilterQuery<LanguageModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'languages');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> personalInfo(
      FilterQuery<PersonalInformation> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'personalInfo');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      professionalSummary(FilterQuery<ProfessionalSummary> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'professionalSummary');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> projectsElement(
      FilterQuery<ProjectModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'projects');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition>
      selectedTemplate(FilterQuery<TemplateSelection> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'selectedTemplate');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterFilterCondition> skillsElement(
      FilterQuery<SkillModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'skills');
    });
  }
}

extension ResumeModelQueryLinks
    on QueryBuilder<ResumeModel, ResumeModel, QFilterCondition> {}

extension ResumeModelQuerySortBy
    on QueryBuilder<ResumeModel, ResumeModel, QSortBy> {
  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> sortByCreatedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdDate', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> sortByCreatedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdDate', Sort.desc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> sortByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> sortByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> sortByResumeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeName', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> sortByResumeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeName', Sort.desc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension ResumeModelQuerySortThenBy
    on QueryBuilder<ResumeModel, ResumeModel, QSortThenBy> {
  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByCreatedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdDate', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByCreatedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdDate', Sort.desc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByLastUpdatedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdated', Sort.desc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByResumeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeName', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByResumeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeName', Sort.desc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension ResumeModelQueryWhereDistinct
    on QueryBuilder<ResumeModel, ResumeModel, QDistinct> {
  QueryBuilder<ResumeModel, ResumeModel, QDistinct> distinctByCreatedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdDate');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QDistinct> distinctByLastUpdated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdated');
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QDistinct> distinctByResumeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resumeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ResumeModel, ResumeModel, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }
}

extension ResumeModelQueryProperty
    on QueryBuilder<ResumeModel, ResumeModel, QQueryProperty> {
  QueryBuilder<ResumeModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ResumeModel, List<CertificationModel>?, QQueryOperations>
      certificationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'certifications');
    });
  }

  QueryBuilder<ResumeModel, DateTime?, QQueryOperations> createdDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdDate');
    });
  }

  QueryBuilder<ResumeModel, List<EducationModel>?, QQueryOperations>
      educationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'education');
    });
  }

  QueryBuilder<ResumeModel, List<ExperienceModel>?, QQueryOperations>
      experienceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'experience');
    });
  }

  QueryBuilder<ResumeModel, List<LanguageModel>?, QQueryOperations>
      languagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languages');
    });
  }

  QueryBuilder<ResumeModel, DateTime?, QQueryOperations> lastUpdatedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdated');
    });
  }

  QueryBuilder<ResumeModel, PersonalInformation?, QQueryOperations>
      personalInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personalInfo');
    });
  }

  QueryBuilder<ResumeModel, ProfessionalSummary?, QQueryOperations>
      professionalSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'professionalSummary');
    });
  }

  QueryBuilder<ResumeModel, List<ProjectModel>?, QQueryOperations>
      projectsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projects');
    });
  }

  QueryBuilder<ResumeModel, String?, QQueryOperations> resumeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resumeName');
    });
  }

  QueryBuilder<ResumeModel, TemplateSelection?, QQueryOperations>
      selectedTemplateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedTemplate');
    });
  }

  QueryBuilder<ResumeModel, List<SkillModel>?, QQueryOperations>
      skillsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skills');
    });
  }

  QueryBuilder<ResumeModel, ResumeStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}
