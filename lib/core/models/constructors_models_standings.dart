import 'package:f1_news/core/models/constructors_models.dart';

class ConstructorModelStandings {
  final ConstructorModel constructor;
  final String position;
  final String points;

  ConstructorModelStandings({
    required this.constructor,
    required this.position,
    required this.points
  });

  factory ConstructorModelStandings.fromJson(Map<String, dynamic> json) {
    final constructorJson = json['Constructor'] ?? {};

    return ConstructorModelStandings(
      constructor: ConstructorModel.fromJson(constructorJson),

      position: json['position'] ?? '0',
      points: json['points'] ?? '0'
    );
  }
}