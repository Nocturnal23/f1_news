import 'package:f1_news/core/models/championship/constructor.dart';
import 'package:f1_news/core/models/championship/driver.dart';
import 'package:f1_news/core/models/sessions/base_result.dart';

//Questo modello è comune alla Sprint e alla gara.
class RaceResultModel extends BaseResultModel{
  final String positionText; //Posizione in strigna.
  final String points; //Punti in base al risultato.
  final String grid; // Potrebbe essere usato come risultato per la Sprint Shotout.
  final String laps; //Giri completati
  final String status; //Lo stato del pilota alla fine (finished, lapped?)

  //Rappresentazione dell'oggetto Time.
  final String totalTime; //Il tempo di gara.

  //Rappresentazione l'oggetto fastestLap, è per ogni pilota.
  final String fastestLapRank; //Può essere l'indice del miglior giro? Rank=1 => Miglior giro in assoluto.
  final String lap; //Quando è stato fatto.
  final String fastestLapTime; //Il tempo del giro.

  RaceResultModel({
    required super.number,
    required super.position,
    required this.positionText,
    required this.points,
    required super.driver,
    required super.constructor,
    required this.grid,
    required this.laps,
    required this.status,
    required this.totalTime,
    required this.fastestLapRank,
    required this.lap,
    required this.fastestLapTime
  });

  factory RaceResultModel.fromJson(Map<String, dynamic> json) {
    final timeData = json['Time'] ?? {};

    final fastestData = json['FastestLap'] ?? {};
    final fastestTimeData = fastestData['Time'] ?? {};

    return RaceResultModel(
      number: json['number'] ?? 'N/A',
      position: json['position'] ?? 'N/A',
      positionText: json['positionText'] ?? 'N/A',
      points: json['points'] ?? '0',
      driver: DriverModel.fromJson(json['Driver']),
      constructor: ConstructorModel.fromJson(json['Constructor']),
      grid: json['grid'] ?? 'N/A',
      laps: json['laps'] ?? '0',
      status: json['status'] ?? 'N/A',

      totalTime: timeData['time'] ?? 'N/A',
      fastestLapRank: fastestData['rank'] ?? 'N/A',
      lap: fastestData['lap'] ?? 'N/A',
      fastestLapTime: fastestTimeData['time'] ?? 'N/A',
    );
  }

  @override
  String get displayPosition => position;

  @override
  List<String> get extraColumns => [
    totalTime == 'N/A' ? status : totalTime,
    points,
  ];

  @override
  bool get hasFastestLap => true;
}