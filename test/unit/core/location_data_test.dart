import 'package:flutter_test/flutter_test.dart';
import 'package:vitafolio/core/data/location_data.dart';
import 'package:vitafolio/features/experience/presentation/widgets/cascading_location_data.dart';

void main() {
  group('Compiled Location Data Tests', () {
    test('Compiled location catalogue is not empty', () {
      expect(kGlobalLocationCatalogue, isNotEmpty);
      expect(LocationDataService.getCountries(), isNotEmpty);
    });

    test('India hierarchy lookups', () {
      final countries = LocationDataService.getCountries();
      expect(countries, contains('India'));

      final states = LocationDataService.getStates('India');
      expect(states, contains('Maharashtra'));
      expect(states, contains('Karnataka'));
      expect(states, contains('West Bengal'));

      final maharashtraCities = LocationDataService.getCities('India', 'Maharashtra');
      expect(maharashtraCities, contains('Mumbai'));

      final karnatakaCities = LocationDataService.getCities('India', 'Karnataka');
      expect(karnatakaCities, contains('Bengaluru'));

      final westBengalCities = LocationDataService.getCities('India', 'West Bengal');
      expect(westBengalCities, contains('Kolkata'));
    });

    test('International hierarchy lookups', () {
      expect(LocationDataService.getCities('United Kingdom', 'England'), contains('London'));
      expect(LocationDataService.getCities('Australia', 'New South Wales'), contains('Sydney'));
      expect(LocationDataService.getCities('United States', 'California'), contains('Los Angeles'));
      expect(LocationDataService.getCities('Canada', 'Ontario'), contains('Toronto'));
      expect(LocationDataService.getCities('Japan', 'Tokyo'), contains('Tokyo'));
    });
  });
}
