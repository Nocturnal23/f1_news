import 'driver.dart';

class DriverModelStanding {
  final DriverModel driver;
  final String teamId;
  final String teamName;
  final String position;
  final String points;

  DriverModelStanding({
    required this.driver,
    required this.teamId,
    required this.teamName,
    required this.position,
    required this.points,
  });

  factory DriverModelStanding.fromJson(Map<String, dynamic> json) {
    // Questi sono i due oggetti annidati nello stadings.
    final driverJson = json['Driver'] ?? {};
    final constructors = json['Constructors'] as List<dynamic>?;
    final retrieveTeamID = constructors != null && constructors.isNotEmpty;

    return DriverModelStanding(
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