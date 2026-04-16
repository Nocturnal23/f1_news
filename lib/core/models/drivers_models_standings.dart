import 'drivers_models.dart';

class DriverModelStandings {
  final DriverModel driver;
  final String teamId;
  final String teamName;
  final String position;
  final String points;

  DriverModelStandings({
    required this.driver,
    required this.teamId,
    required this.teamName,
    required this.position,
    required this.points,
  });

  factory DriverModelStandings.fromJson(Map<String, dynamic> json) {
    // Questi sono i due oggetti annidati nello stadings.
    final driverJson = json['Driver'] ?? {};
    final constructors = json['Constructors'] as List<dynamic>?;
    final retrieveTeamID = constructors != null && constructors.isNotEmpty;

    return DriverModelStandings(
      //Qua vengono salvate le info base del pilota.
      driver: DriverModel.fromJson(driverJson),

      teamId: retrieveTeamID
          ? (constructors[0]['constructorId'] ?? 'N/A')
          : 'N/A',
      teamName: (constructors != null && constructors.isNotEmpty)
          ? (constructors[0]['name'] ?? 'N/A')
          : 'N/A',

      position: json['position'] ?? '0',
      points: json['points'] ?? '0',
    );
  }
}