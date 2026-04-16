import '../models/drivers_models_standings.dart';
import '../models/drivers_models.dart';
import '../services/jolpica_service.dart';

class F1Repository {
  final ApiService apiService;

  F1Repository(this.apiService);

  //Repo per i piloti che sono in classifica.
  Future<List<DriverModelStandings>> fetchDriversStandings() async {
    try {
      final data = await apiService.getDriversStandings();

      if (data['MRData'] != null &&
          data['MRData']['StandingsTable'] != null &&
          data['MRData']['StandingsTable']['StandingsLists'] != null) {

        final List<dynamic> standingsLists = data['MRData']['StandingsTable']['StandingsLists'];

        if (standingsLists.isNotEmpty) {
          final List<dynamic>? standingsJson = standingsLists[0]['DriverStandings'];

          if (standingsJson != null) {
            return standingsJson
                .map((json) => DriverModelStandings.fromJson(json))
                .toList();
          }
        }
      }
      return [];
    } catch (e) {
      print("Errore nel repository: $e");
      rethrow;
    }
  }

  //Repo per tutti i piloti che hanno preso parte ad almeno una sessione ufficiela.
  Future<List<DriverModel>> fetchDrivers() async {
    try {
      final data = await apiService.getDrivers();

      if (data['MRData'] != null &&
          data['MRData']['DriverTable'] != null &&
          data['MRData']['DriverTable']['Drivers'] != null) {

        final List<dynamic> driversJson =
        data['MRData']['DriverTable']['Drivers'];

        return driversJson
            .map((json) => DriverModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      print("Errore nel repository: $e");
      rethrow;
    }
  }
}