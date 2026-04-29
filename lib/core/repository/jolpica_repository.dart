import 'package:f1_news/core/models/race_model.dart';

import '../models/driver_model_standing.dart';
import '../models/driver_model.dart';
import '../models/constructor_model.dart';
import '../models/constructor_model_standing.dart';
import '../services/jolpica_service.dart';

class F1Repository {
  final ApiService apiService;

  F1Repository(this.apiService);

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

  //Repo per i piloti che sono in classifica.
  Future<List<DriverModelStanding>> fetchDriversStandings() async {
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
                .map((json) => DriverModelStanding.fromJson(json))
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

  //Repo per tutti i tutti teams.
  Future<List<ConstructorModel>> fetchTeams() async {
    try {
      final data = await apiService.getTeams();

      if (data['MRData'] != null &&
          data['MRData']['ConstructorTable'] != null &&
          data['MRData']['ConstructorTable']['Constructors'] != null) {

        final List<dynamic> teamsJson =
        data['MRData']['ConstructorTable']['Constructors'];

        return teamsJson
            .map((json) => ConstructorModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print("Errore nel repository: $e");
      rethrow;
    }
  }

  //Repo per i teams in classifica.
  Future<List<ConstructorModelStanding>> fetchTeamsStandings() async {
    try {
      final data = await apiService.getTeamsStandings();

      if (data['MRData'] != null &&
          data['MRData']['StandingsTable'] != null &&
          data['MRData']['StandingsTable']['StandingsLists'] != null) {
        final List<dynamic> standingsLists = data['MRData']['StandingsTable']['StandingsLists'];

        if (standingsLists.isNotEmpty) {
          final List<dynamic>? standingsJson = standingsLists[0]['ConstructorStandings'];

          if (standingsJson != null) {
            return standingsJson
                .map((json) => ConstructorModelStanding.fromJson(json))
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

  //Repo per il calendario
  Future<List<RaceModel>> fetchCalendar() async {
    try {
      final data = await apiService.getRaces();

      if(data['MRData'] != null &&
         data['MRData']['RaceTable'] != null &&
         data['MRData']['RaceTable']['Races'] != null) {

        final List<dynamic> racesList = data['MRData']['RaceTable']['Races'];

        return racesList.map((json) => RaceModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Errore nel repository $e");
      rethrow;
    }
  }

  // Questo filtro mi permette di selezionare i piloti ufficiali, senza seguire la classifica.
  Future<List<DriverModelStanding>> fetchOfficialDriversByTeam() async {
    // Qui vengono recuperati i piloti ufficiali.
    final List<DriverModelStanding> standings = await fetchDriversStandings();

    // Quindi prendo i piloti ufficuali e li ordino per team di appartenenza.
    // Se ho fatto bene se durante la stagione un pilota viene sostituito
    // temporaneamente o definitivamente viene comunque mostrato e viene
    // mostrato anche il sostituto.
    standings.sort((a, b) {
      int compareTeam = a.teamName.compareTo(b.teamName);
      if (compareTeam != 0) return compareTeam;
      return a.driver.surname.compareTo(b.driver.surname);
    });

    return standings;
  }
}