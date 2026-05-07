import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.jolpi.ca/ergast/f1';

  //Endpoint per i piloti presenti in classifica.
  Future<Map<String, dynamic>> getDriversStandings() async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/driverStandings.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento dei piloti: ${response.statusCode}');
    }
  }

  //Endpoint per tutti i piloti che hanno preso parte ad almeno una sessione ufficiale.
  Future<Map<String, dynamic>> getDrivers() async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/drivers.json?limit=100'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento dei piloti: ${response.statusCode}');
    }
  }

  //Endpoint per i teams.
  Future<Map<String, dynamic>> getTeams() async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/constructors.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento dei team: ${response.statusCode}');
    }
  }

  //Endpoint per la classifica teams.
  Future<Map<String, dynamic>> getTeamsStandings() async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/constructorStandings.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento dei team: ${response.statusCode}');
    }
  }

  //Endpoit per le gare in calendario
  Future<Map<String, dynamic>> getRaces() async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/races.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento del calendario: ${response.statusCode}');
    }
  }

  //E' parte del recupero del ultimo vincitore.
  Future<Map<String, dynamic>> getWinnersMetadata(String circuit_id) async {
    final response = await http.get(
        Uri.parse('$baseUrl/circuits/$circuit_id/results/1.json?limit=1'));
    if (response.statusCode == 200) {
      print("Contenuto risposta metadata: ${response.body}");
      return jsonDecode(response.body);
    } else {
      throw Exception('Errore caricamento metadati');
    }
  }

  //Endpoint per recuperare il vincitore dell'ultima edizione disputata di un GP.
  Future<Map<String, dynamic>> getLastWinner(String circuit_id,
      int offset) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/circuits/$circuit_id/results/1.json?limit=1&offset=$offset'));

    if (response.statusCode == 200) {
      print("Contenuto risposta ultimo vincitore: ${response.body}");
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento del calendario: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getExtraInfo() async {
    final response = await http.get(Uri.parse(
        'https://gist.githubusercontent.com/Nocturnal23/421160de818f6c42d40a57b0edfbb4a5/raw/f1_news_circuits_extra_data.json'));

    if (response.statusCode == 200) {
      print("Contenuto risposta dati extra: ${response.body}");
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento del json personalizzato: ${response
              .statusCode}');
    }
  }

  //Endpoint per i risultati della Sprint
  Future<Map<String, dynamic>> getSprintResult(String round) async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/${round}/sprint.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento della sprint: ${response.statusCode}');
    }
  }

  //Endpoint per i risultati della qualifica
  Future<Map<String, dynamic>> getQualiResult(String round) async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/${round}/qualifying.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Errore nel caricamento delle qualifiche: ${response
          .statusCode}');
    }
  }

  //Endpoint per i risultati di gara.
  Future<Map<String, dynamic>> getRaceResult(String round) async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/${round}/results.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Errore nel caricamento delle qualifiche: ${response
          .statusCode}');
    }
  }
}