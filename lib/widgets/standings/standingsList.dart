import 'package:flutter/material.dart';

import '../../core/repository/jolpica_repository.dart';
import '../../core/services/jolpica_service.dart';

class StandingsList extends StatelessWidget {
  final String
  type; //Assume i valori "drivers" o "constructors" per capire cosa mostrare.
  StandingsList({super.key, required this.type});

  final F1Repository _repository = F1Repository(ApiService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: type == "drivers"
          ? _repository.fetchDriversStandings()
          : _repository.fetchTeamsStandings(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.red)));
        } else if (snapshot.hasError) {
          return Text("Errore: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Nessun dato disponibile!");
        }

        final data = snapshot.data!;
        return Container(
          color: Colors.black,

          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Classifica ${DateTime.now().year}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                DataTable(
                  //Intestazione
                  columns: [
                    const DataColumn(
                      label: Text(
                        'Pos.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        type == "drivers" ? 'Pilota' : 'Team',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Nazione',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Punti',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],

                  //Dati
                  rows: List<DataRow>.generate(data.length, (index) {
                    final item = data[index];
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            "${index + 1}°",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            type == "drivers"
                                ? item.driver.surname
                                : item.constructor.name,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            type == "drivers"
                              ? item.driver.nationality.substring(0, 3).toUpperCase()
                              : item.constructor.nationality.substring(0, 3).toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataCell(
                          Text(
                            "${item.points}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
