import 'country_codes.dart';

class LocalCountriesDataSource {
  const LocalCountriesDataSource();

  Future<String?> getFlagSvgByCountryName(String name) async {
    final code = CountryCodes.getIsoCode(name);
    if (code != null) {
      return 'https://flagcdn.com/w80/${code.toLowerCase()}.png';
    }
    return null;
  }
}
