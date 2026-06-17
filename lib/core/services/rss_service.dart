import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../providers/network_monitor.dart';

class RssService {
  Future<String> fetchRawXml(String url) async {
    if (!isAppConnected) {
      throw const SocketException('Nessuna connessione a Internet');
    }

    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException('Il server ha impiegato troppo tempo per rispondere.');
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Errore durante la connessione: ${response.statusCode}');
    }
  }
}