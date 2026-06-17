import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';

class ApiService {
  static const String baseUrl = 'https://api.jolpi.ca/ergast/f1';

  Future<bool> _hasConnection() async {
    return InternetConnection().hasInternetAccess;
  }

  //Endpoint per i piloti presenti in classifica.
  Future<Map<String, dynamic>> getDriversStandings() async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/driverStandings.json')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento dei piloti: ${response.statusCode}');
    }
  }

  //Endpoint per tutti i piloti che hanno preso parte ad almeno una sessione ufficiale.
  Future<Map<String, dynamic>> getDrivers() async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/drivers.json?limit=100')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento dei piloti: ${response.statusCode}');
    }
  }

  //Endpoint per i teams.
  Future<Map<String, dynamic>> getTeams() async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/constructors.json')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento dei team: ${response.statusCode}');
    }
  }

  //Endpoint per la classifica teams.
  Future<Map<String, dynamic>> getTeamsStandings() async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/constructorStandings.json')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento dei team: ${response.statusCode}');
    }
  }

  //Endpoit per le gare in calendario
  Future<Map<String, dynamic>> getRaces() async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/races.json')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento del calendario: ${response.statusCode}');
    }
  }

  //E' parte del recupero del ultimo vincitore.
  Future<Map<String, dynamic>> getWinnersMetadata(String circuit_id) async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(
        Uri.parse('$baseUrl/circuits/$circuit_id/results/1.json?limit=1')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Errore caricamento metadati');
    }
  }

  //Endpoint per recuperare il vincitore dell'ultima edizione disputata di un GP.
  Future<Map<String, dynamic>> getLastWinner(String circuit_id, int offset) async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse(
        '$baseUrl/circuits/$circuit_id/results/1.json?limit=1&offset=$offset')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento del calendario: ${response.statusCode}');
    }
  }

  //Extra info sui circuiti.
  Future<Map<String, dynamic>> getExtraInfo() async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse(
        'https://gist.githubusercontent.com/Nocturnal23/421160de818f6c42d40a57b0edfbb4a5/raw/f1_news_circuits_extra_data.json')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento del json personalizzato: ${response
              .statusCode}');
    }
  }

  //Endpoint per i risultati della Sprint
  Future<Map<String, dynamic>> getSprintResult(String round) async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/${round}/sprint.json')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Errore nel caricamento della sprint: ${response.statusCode}');
    }
  }

  //Endpoint per i risultati della qualifica
  Future<Map<String, dynamic>> getQualiResult(String round) async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/${round}/qualifying.json')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Errore nel caricamento delle qualifiche: ${response
          .statusCode}');
    }
  }

  //Endpoint per i risultati di gara.
  Future<Map<String, dynamic>> getRaceResult(String round) async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse('$baseUrl/${DateTime
        .now()
        .year}/${round}/results.json')).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
        });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Errore nel caricamento delle qualifiche: ${response
          .statusCode}');
    }
  }

  //Extra info su piloti o team.
  Future<Map<String, dynamic>> getExtraCompetitorInfo(type) async {
    final connected = await _hasConnection();

    if (!connected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    late http.Response response;
    if (type == "drivers") {
      response = await http.get(Uri.parse('https://gist.githubusercontent.com/Nocturnal23/3b01177e7915a872ef45c04c3abcdf0e/raw/f1_news_drivers_extra_data.json')).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
          });
    } else {
      response = await http.get(Uri.parse('https://gist.githubusercontent.com/Nocturnal23/aa533cb0334d4e9eccc3b9f61cdf874f/raw/f1_news_constructors_extra_data.json')).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Il server ha impiegato troppo tempo per rispondere. Riprova.');
          });
    }

    if (response.statusCode == 200) {
      print("Contenuto risposta dati extra: ${response.body}");
      return jsonDecode(response.body);
    } else {
      throw Exception('Errore nel caricamento del json personalizzato: ${response.statusCode}');
    }
  }
}