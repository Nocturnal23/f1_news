import '../constructor_model.dart';
import '../driver_model.dart';

//Classe comune ai modelli relativi a gare (sprint e gara) e qualifica.
abstract class BaseResultModel {
  final String number;
  final String position;
  final DriverModel driver;
  final ConstructorModel constructor;

  BaseResultModel({
    required this.position,
    required this.number,
    required this.driver,
    required this.constructor,
  });
}