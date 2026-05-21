/*
Questa classe raccoglie soolo i dati relativi al pilota.
 */

class DriverModel {
  final String id;
  final String name;
  final String surname;
  final String nationality;
  final String code;
  final String dateOfBirth;

  DriverModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.nationality,
    required this.code,
    required this.dateOfBirth,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['driverId'] ?? 'N/A',
      name: json['givenName'] ?? 'N/A',
      surname: json['familyName'] ?? 'N/A',
      nationality: json['nationality'] ?? 'N/A',
      code: json['code'] ?? 'N/A',
      dateOfBirth: json['dateOfBirth'] ?? 'N/A'
    );
  }
}