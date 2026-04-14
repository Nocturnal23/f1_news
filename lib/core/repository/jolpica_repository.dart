import '../models/drivers_models.dart';
import '../services/jolpica_service.dart';

class F1Repository {
  final ApiService apiService;

  F1Repository(this.apiService);

  // Future<List<DriverModel>> fetchDrivers() async {
  //   final data = await apiService.getDrivers();
  //
  //   final driversJson = data['MRData']['DriverTable']['Drivers'];
  //
  //   return driversJson
  //       .map<DriverModel>((json) => DriverModel.fromJson(json))
  //       .toList();
  // }

  Future<List<DriverModel>> fetchDrivers() async {
    try {
      final data = await apiService.getDrivers();

      if (data['MRData'] != null &&
          data['MRData']['DriverTable'] != null &&
          data['MRData']['DriverTable']['Drivers'] != null) {

        final List<dynamic> driversJson = data['MRData']['DriverTable']['Drivers'];

        return driversJson
            .map((json) => DriverModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Errore nel repository: $e");
      rethrow;
    }
  }
}