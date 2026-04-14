import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.jolpi.ca/ergast/f1';

  Future<Map<String, dynamic>> getDrivers() async {
    final response = await http.get(Uri.parse('$baseUrl/${DateTime.now().year}/drivers.json'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Errore nel caricamento dei piloti: ${response.statusCode}');
    }
  }
}