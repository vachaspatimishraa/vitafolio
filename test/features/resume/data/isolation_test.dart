import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:vitafolio/features/resume/data/models/resume_model.dart';
import 'package:vitafolio/features/resume/data/datasources/resume_local_datasource.dart';
import 'dart:io';

void main() {
  late Isar isar;
  late ResumeLocalDataSource dataSource;
  late String tempPath;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    tempPath = Directory.systemTemp.createTempSync('isar_test').path;
  });

  setUp(() async {
    isar = await Isar.open(
      [ResumeDbModelSchema],
      directory: tempPath,
    );
    dataSource = ResumeLocalDataSourceImpl(isar);
  });

  tearDown(() async {
    await isar.close();
  });

  test('Resume A and Resume B should remain isolated', () async {
    final resumeA = ResumeDbModel()
      ..title = 'Resume A'
      ..selectedTemplateId = 'temp1'
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    final resumeB = ResumeDbModel()
      ..title = 'Resume B'
      ..selectedTemplateId = 'temp2'
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    final savedA = await dataSource.createResume(resumeA);
    final savedB = await dataSource.createResume(resumeB);

    expect(savedA.id, isNot(savedB.id));

    savedA.title = 'Updated A';
    await dataSource.updateResume(savedA);

    final fetchedB = await dataSource.getResume(savedB.id!);
    expect(fetchedB?.title, 'Resume B');
  });
}
