class DriverModel {
  final String id;
  final String name;
  final String surname;
  final String nationality;
  final String? code;

  DriverModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.nationality,
    this.code,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['driverId'],
      name: json['givenName'] ?? 'N/A',
      surname: json['familyName'] ?? 'N/A',
      nationality: json['nationality'] ?? 'N/A',
      code: json['code'],
    );
  }
}