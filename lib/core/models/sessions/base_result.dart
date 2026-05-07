import '../constructor.dart';
import '../driver.dart';

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

  //Getter per capire quali colonne considerare in base alla sessione:
  String get displayPosition;

  List<String> get extraColumns; //Colonna dinamica.

  bool get hasFastestLap => false;
}