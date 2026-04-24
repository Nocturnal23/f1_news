import 'package:countries_utils/countries_utils.dart';

class CountryHelper {
  static const Map<String, String> countryAlias = {
    "UK": "United Kingdom of Great Britain and Northern Ireland",
    "USA": "United States of America",
    "UAE": "United Arab Emirates",
  };

  static String getIsoCode(String? countryName) {
    String? cleanName = countryAlias[countryName] ?? countryName;

    try {
      final country = Countries.byName(cleanName!);
      return country?.alpha2Code ?? "";
    } catch (e) {
      return "";
    }
  }
}