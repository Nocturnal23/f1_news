import 'package:f1_news/core/models/championship/constructor.dart';

class ConstructorModelStanding {
  final ConstructorModel constructor;
  final String position;
  final String points;
  final String wins;

  ConstructorModelStanding({
    required this.constructor,
    required this.position,
    required this.points,
    required this.wins
  });

  factory ConstructorModelStanding.fromJson(Map<String, dynamic> json) {
    final constructorJson = json['Constructor'] ?? {};

    return ConstructorModelStanding(
      constructor: ConstructorModel.fromJson(constructorJson),

      position: json['position'] ?? '0',
      points: json['points'] ?? '0',
      wins: json['wins'] ?? '0'
    );
  }
}