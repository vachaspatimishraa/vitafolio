import 'package:vitafolio/core/data/location_data.dart';

/// Single shared location service consuming the compiled kGlobalLocationCatalogue.
class LocationDataService {
  const LocationDataService();

  static final Map<String, Map<String, List<String>>> _map = {
    for (final country in kGlobalLocationCatalogue)
      country.name: {
        for (final state in country.states) state.name: state.cities,
      },
  };

  static List<String> getCountries() {
    return _map.keys.toList();
  }

  static List<String> getStates(String? country) {
    if (country == null || !_map.containsKey(country)) {
      return _map.values.expand((m) => m.keys).toSet().toList();
    }
    return _map[country]!.keys.toList();
  }

  static List<String> getCities(String? country, String? state) {
    if (country != null && _map.containsKey(country)) {
      final countryMap = _map[country]!;
      if (state != null && countryMap.containsKey(state)) {
        return countryMap[state]!;
      }
      return countryMap.values.expand((element) => element).toSet().toList();
    }
    return _map.values
        .expand((m) => m.values.expand((c) => c))
        .toSet()
        .toList();
  }
}

/// Backward compatibility wrapper redirecting to LocationDataService.
class CascadingLocationData {
  static List<String> getCountries() => LocationDataService.getCountries();
  static List<String> getStates(String? country) => LocationDataService.getStates(country);
  static List<String> getCities(String? country, String? state) => LocationDataService.getCities(country, state);
}
