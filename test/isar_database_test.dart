import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/database/database_constants.dart';
import 'package:vitafolio/data/datasource/isar_service.dart';

void main() {
  test('Isar database constants check', () {
    expect(DatabaseConstants.databaseName, equals('vitafolio'));
    expect(DatabaseConstants.collections.isNotEmpty, isTrue);
  });

  test('IsarService singleton instance check', () {
    final service = IsarService.instance;
    expect(service, isNotNull);
    expect(service.isInitialized, isFalse);
  });
}
