class DriverModelStandings {
  final String id;
  final String name;
  final String surname;
  final String nationality;
  final String code;
  final String teamName;

  DriverModelStandings({
    required this.id,
    required this.name,
    required this.surname,
    required this.nationality,
    required this.code,
    required this.teamName
  });

  factory DriverModelStandings.fromJson(Map<String, dynamic> json) {
    final driverJson = json['Driver'] ?? {};
    final constructors = json['Constructors'] as List<dynamic>?;

    return DriverModelStandings(
      id: driverJson['driverId'],
      name: driverJson['givenName'] ?? 'N/A',
      surname: driverJson['familyName'] ?? 'N/A',
      nationality: driverJson['nationality'] ?? 'N/A',
      code: driverJson['code'] ?? 'N/A',

      teamName: (constructors != null && constructors.isNotEmpty)
          ? (constructors[0]['name'] ?? 'N/A')
          : 'N/A',
    );
  }
}