import 'package:f1_news/core/models/constructor.dart';

class ConstructorModelStanding {
  final ConstructorModel constructor;
  final String position;
  final String points;

  ConstructorModelStanding({
    required this.constructor,
    required this.position,
    required this.points
  });

  factory ConstructorModelStanding.fromJson(Map<String, dynamic> json) {
    final constructorJson = json['Constructor'] ?? {};

    return ConstructorModelStanding(
      constructor: ConstructorModel.fromJson(constructorJson),

      position: json['position'] ?? '0',
      points: json['points'] ?? '0'
    );
  }
}