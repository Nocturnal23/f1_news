class ConstructorModel {
  final String id;
  final String name;
  final String nationality;

  ConstructorModel({
    required this.id,
    required this.name,
    required this.nationality
  });

  factory ConstructorModel.fromJson(Map<String, dynamic> json) {
    return ConstructorModel(
      id: json['constructorId'] ?? 'N/A',
      name: json['name'] ?? 'N/A',
      nationality: json['nationality'] ?? 'N/A',
    );
  }
}

