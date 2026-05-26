class ConstructorDetails {
  final String name;
  final String base;
  final String country;
  final String debut;
  final List<String> teamChief;
  final List<String> technicalChief;
  final String chassis;
  final String powerUnit;
  final int gpDisputed;
  final int gpWin;
  final double totalPoints;
  final int wdcConstructor;
  final int wdcDriver;
  final List<String> reserveDriver;

  ConstructorDetails({
    required this.name,
    required this.base,
    required this.country,
    required this.debut,
    required this.teamChief,
    required this.technicalChief,
    required this.chassis,
    required this.powerUnit,
    required this.gpDisputed,
    required this.gpWin,
    required this.totalPoints,
    required this.wdcConstructor,
    required this.wdcDriver,
    required this.reserveDriver,
  });

  factory ConstructorDetails.fromJson(Map<String, dynamic> json) {
    return ConstructorDetails(
      name: json['nome'] ?? 'F1_Team',
      debut: json['debut'] ?? 'TBC',
      base: json['base'] ?? 'N/A',
      country: json['country'] ?? 'N/A',
      teamChief: List<String>.from(json['teamChief'] ?? []),
      technicalChief: List<String>.from(json['technicalChief'] ?? []),
      chassis: json['chassis'] ?? 0,
      powerUnit: json['powerUnit'] ?? 'N/A',
      gpDisputed: json['gpDisputed'] ?? 0,
      gpWin: json['gpWin'] ?? 0,
      totalPoints: (json['totalPoints'] ?? 0).toDouble(),
      wdcConstructor: json['wdcConstructor'] ?? 0,
      wdcDriver: json['wdcDriver'] ?? 0,
      reserveDriver: List<String>.from(json['reserveDriver'] ?? []),
    );
  }
}
