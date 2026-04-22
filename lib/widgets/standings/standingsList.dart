import 'package:f1_news/core/models/constructors_models_standings.dart';
import 'package:flutter/material.dart';

import '../../core/models/drivers_models_standings.dart';
import '../../core/repository/jolpica_repository.dart';
import '../../core/services/jolpica_service.dart';

class StandingsList extends StatelessWidget {
  final String type; //Assume i valori "drivers" o "constructors" per capire cosa mostrare.
  StandingsList({super.key, required this.type});

  final F1Repository _repository = F1Repository(ApiService());

  // late Future<List<dynamic>> _standingsFuture;
  //
  // late Future<List<ConstructorModelStandings>> _constructorFuture;
  //
  // late Future<List<DriverModelStandings>> _driversFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: type == "drivers"
          ? _repository.fetchDriversStandings()
          : _repository.fetchTeamsStandings(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(color: Colors.red);
          } else if (snapshot.hasError) {
            return Text("Errore: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("Nessun dato disponibile!");
          }

          final data = snapshot.data!;
          return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 1),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                return ListTile(
                  title: Text(type == "drivers" ? item.driver.surname : item.constructor.name),
                  subtitle: Text("Punti: ${item.points}"),
                  leading: Text("${index + 1}°"),
                );
              }
          );
        }
    );
  }
}
