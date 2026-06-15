import 'package:countries_utils/countries_utils.dart';

class CountryHelper {
  static const Map<String, String> countryAlias = {
    "UK": "United Kingdom of Great Britain and Northern Ireland",
    "USA": "United States of America",
    "UAE": "United Arab Emirates",
  };

  static const Map<String, String> _nationalityToIso = {
    'British': 'gb',
    'German': 'de',
    'Spanish': 'es',
    'Finnish': 'fi',
    'Japanese': 'jp',
    'French': 'FR',
    'Mexican': 'mx',
    'Monegasque': 'mc',
    'Australian': 'au',
    'Austrian': 'at',
    'Dutch': 'nl',
    'Canadian': 'ca',
    'Thai': 'th',
    'Chinese': 'cn',
    'American': 'us',
    'Italian': 'it',
    'Swiss': 'ch',
    'New Zealander': 'nz',
    'Argentine': 'ar',
    'Brazilian': 'br',
    'Danish': 'dk',
    'Belgian': 'be',
    'Colombian': 'co',
    'Polish': 'pl',
    'Russian': 'ru',
    'Swedish': 'se',
    'Venezuelan': 've',
    'Indian': 'in',
    'Indonesian': 'id',
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

  static String getIsoCodeFromNationality(String nationality) {
    if (nationality.isEmpty) return '';
    String code = _nationalityToIso[nationality]?.toUpperCase() ?? '';
    try {
      final country = Countries.byCode(code);
      return country?.alpha2Code ?? "";
    } catch (e) {
      return "";
    }
  }
}