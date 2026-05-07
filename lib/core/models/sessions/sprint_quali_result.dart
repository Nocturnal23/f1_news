import '../constructor.dart';
import '../driver.dart';
import 'base_result.dart';

class SprintGridResultModel extends BaseResultModel {
  final String grid;

  SprintGridResultModel({
    required super.position, //Seppur non lo uso, devo per forza inserirlo, ma userò grid.
    required super.number,
    required super.driver,
    required super.constructor,
    required this.grid,
  });

  factory SprintGridResultModel.fromJson(Map<String, dynamic> json) {
    return SprintGridResultModel(
      number: json['number'] ?? 'N/A',
      position: json['position'] ?? 'N/A',
      driver: DriverModel.fromJson(json['Driver']),
      constructor: ConstructorModel.fromJson(json['Constructor']),
      grid: json['grid'] ?? '0',
    );
  }

  @override
  String get displayPosition => grid;

  @override
  List<String> get extraColumns => [];
}