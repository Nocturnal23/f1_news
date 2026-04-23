import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter/material.dart';

import '../../core/repository/jolpica_repository.dart';
import '../../core/services/jolpica_service.dart';
import '../../widgets/navigation/app_bar_custom.dart';

class Races extends StatelessWidget {
  Races({super.key});

  final F1Repository _repository = F1Repository(ApiService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "Calendario"),

      drawer: const DrawerApp(),

      body: FutureBuilder<List<dynamic>>(
        future: _repository.fetchCalendar(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.red)),
            );
          } else if (snapshot.hasError) {
            return Text("Errore: ${snapshot.error}");
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text("Nessun dato disponibile!");
          }

          final data = snapshot.data!;
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Calendario ${DateTime.now().year}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                      ),
                    ),
                  ),

                  //Lista del calendario
                  DataTable(
                    columns: [
                      const DataColumn(
                        label: Text(
                          'Round',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                      ),

                      const DataColumn(
                        label: Text(
                          'Gran Premio',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                      ),

                      const DataColumn(
                        label: Text(
                          'Circuito',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                      ),

                      const DataColumn(
                        label: Text(
                          'Data',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.white,
                          ),
                        ),
                      ),
                    ],

                    rows: List<DataRow>.generate(data.length, (index) {
                      final item = data[index];
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(
                              "${item.round}",
                              // style: TextStyle(color: Colors.white),
                            ),
                          ),

                          DataCell(
                            Text(
                              "${item.raceName}",
                              // style: TextStyle(color: Colors.white),
                            ),
                          ),

                          DataCell(
                            Text(
                              "${item.circuitName}",
                              // style: TextStyle(color: Colors.white),
                            ),
                          ),

                          DataCell(
                            Text(
                              "${item.date}",
                              // style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
