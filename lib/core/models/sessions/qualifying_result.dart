import 'package:f1_news/core/models/sessions/base_result.dart';

import '../constructor.dart';
import '../driver.dart';

class QualifyingResultModel extends BaseResultModel {
  final String q1;
  final String q2;
  final String q3;

  QualifyingResultModel({
    required super.position,
    required super.number,
    required super.driver,
    required super.constructor,
    required this.q1,
    this.q2 = "",
    this.q3 = "",
  });

  factory QualifyingResultModel.fromJson(Map<String, dynamic> json) {
    return QualifyingResultModel(
      position: json['position'] ?? 'N/A',
      number: json['number'] ?? 'N/A',
      driver: DriverModel.fromJson(json['Driver']),
      constructor: ConstructorModel.fromJson(json['Constructor']),

      q1: json['Q1'] ?? '',
      q2: json['Q2'] ?? '',
      q3: json['Q3'] ?? '',
    );
  }

  @override
  String get displayPosition => position;

  @override
  List<String> get extraColumns => [q1, q2, q3];
}
