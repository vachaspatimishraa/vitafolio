import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/database/database_provider.dart';

void main() {
  group('DatabaseProvider', () {
    test('isarProvider should return null when database not initialized', () {
      final container = ProviderContainer();

      expect(container.read(isarProvider), isNull);
    });

    test('isarServiceProvider should return the IsarService instance', () {
      final container = ProviderContainer();

      expect(container.read(isarServiceProvider), isNotNull);
    });
  });
}
