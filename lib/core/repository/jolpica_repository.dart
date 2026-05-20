import 'package:f1_news/core/models/championship/race.dart';
import 'package:f1_news/core/models/sessions/qualifying_result.dart';
import 'package:f1_news/core/models/sessions/race_result.dart';

import '../models/championship/driver_standing.dart';
import '../models/championship/driver.dart';
import '../models/championship/constructor.dart';
import '../models/championship/constructor_standing.dart';
import '../models/championship/race_details.dart';
import '../models/sessions/sprint_quali_result.dart';
import '../services/jolpica_service.dart';

class F1Repository {
  final ApiService apiService;

  F1Repository(this.apiService);

  Map<String, dynamic>? _cachedExtraData;

  //Repo per tutti i piloti che hanno preso parte ad almeno una sessione ufficiela.
  Future<List<DriverModel>> fetchDrivers() async {
    try {
      final data = await apiService.getDrivers();

      if (data['MRData'] != null &&
          data['MRData']['DriverTable'] != null &&
          data['MRData']['DriverTable']['Drivers'] != null) {
        final List<dynamic> driversJson =
            data['MRData']['DriverTable']['Drivers'];

        return driversJson.map((json) => DriverModel.fromJson(json)).toList();
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
        final List<dynamic> standingsLists =
            data['MRData']['StandingsTable']['StandingsLists'];

        if (standingsLists.isNotEmpty) {
          final List<dynamic>? standingsJson =
              standingsLists[0]['DriverStandings'];

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
        final List<dynamic> standingsLists =
            data['MRData']['StandingsTable']['StandingsLists'];

        if (standingsLists.isNotEmpty) {
          final List<dynamic>? standingsJson =
              standingsLists[0]['ConstructorStandings'];

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

      if (data['MRData'] != null &&
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
    final List<DriverModelStanding> standings = await fetchDriversStandings();

    standings.sort((a, b) {
      int compareTeam = a.teamName.compareTo(b.teamName);
      if (compareTeam != 0) return compareTeam;
      return a.driver.surname.compareTo(b.driver.surname);
    });

    return standings;
  }

  // Recupero dei dati per la prima edizione e ultimo vincitore.
  Future<Map<String, dynamic>> _getMetadata(String circuitId) {
    return apiService.getWinnersMetadata(circuitId);
  }

  // Recupero dati extra (con cache)
  Future<Map<String, dynamic>> _getExtraData() async {
    if (_cachedExtraData != null) {
      return _cachedExtraData!;
    }

    try {
      _cachedExtraData = await apiService.getExtraInfo();
      return _cachedExtraData!;
    } catch (e) {
      print("Errore nel recupero dati extra: $e");
      return {};
    }
  }

  Future<RaceDetailsModel> fetchRaceDetails(String circuitId) async {
    final metadata = await _getMetadata(circuitId);

    final allExtraData = await _getExtraData();

    final currentCircuitExtraData = allExtraData[circuitId];

    final races = metadata['MRData']?['RaceTable']?['Races'] as List?;

    final firstEdition = (races != null && races.isNotEmpty)
        ? races.first['season'].toString()
        : 'N/A';

    final total = int.tryParse(metadata['MRData']?['total'] ?? '') ?? 0;

    String lastWinner = 'N/A';

    if (total > 0) {
      final last = await apiService.getLastWinner(circuitId, total - 1);
      final race = last['MRData']?['RaceTable']?['Races']?[0];
      final driver = race?['Results']?[0]?['Driver'];

      if (driver != null) {
        lastWinner =
            "${driver['givenName']} ${driver['familyName']} (${race['season']})";
      }
    }

    final dataCircuit = {
      'firstEdition': firstEdition,
      'lastWinner': lastWinner,
    };

    return RaceDetailsModel.fromMultiJson(dataCircuit, currentCircuitExtraData);
  }

  //Repo generico che va poi a differenziare SQ, SR e race.
  Future<List<T>> _fetchSession<T>({
    required String round,
    required Future<Map<String, dynamic>> Function(String round) apiCall,
    required List<T> Function(List<dynamic> json) mapper,
    required List<dynamic> Function(Map<String, dynamic> race) extractResults,
  }) async {
    try {
      final data = await apiCall(round);

      final races = data['MRData']?['RaceTable']?['Races'] ?? [];

      if (races.isEmpty) {
        return [];
      }

      final results = extractResults(races[0]);

      return mapper(results);
    } catch (e) {
      print("Errore repo: $e");
      rethrow;
    }
  }

  //SQ
  Future<List<SprintGridResultModel>> fetchSprintGrid(String round) {
    return _fetchSession<SprintGridResultModel>(
      round: round,
      apiCall: apiService.getSprintResult,
      mapper: (jsonList) =>
          jsonList.map((j) => SprintGridResultModel.fromJson(j)).toList(),
      extractResults: (race) => race['SprintResults'] ?? [],
    );
  }

  //SR
  Future<List<RaceResultModel>> fetchSprintResult(String round) {
    return _fetchSession<RaceResultModel>(
      round: round,
      apiCall: apiService.getSprintResult,
      mapper: (jsonList) =>
          jsonList.map((j) => RaceResultModel.fromJson(j)).toList(),
      extractResults: (race) => race['SprintResults'] ?? [],
    );
  }

  //Qualifica
  Future<List<QualifyingResultModel>> fetchQualiResult(String round) {
    return _fetchSession<QualifyingResultModel>(
      round: round,
      apiCall: apiService.getQualiResult,
      mapper: (jsonList) =>
          jsonList.map((j) => QualifyingResultModel.fromJson(j)).toList(),
      extractResults: (race) => race['QualifyingResults'] ?? [],
    );
  }

  // Race
  Future<List<RaceResultModel>> fetchRaceResult(String round) {
    return _fetchSession<RaceResultModel>(
      round: round,
      apiCall: apiService.getRaceResult,
      mapper: (jsonList) =>
          jsonList.map((j) => RaceResultModel.fromJson(j)).toList(),
      extractResults: (race) => race['Results'] ?? [],
    );
  }
}
