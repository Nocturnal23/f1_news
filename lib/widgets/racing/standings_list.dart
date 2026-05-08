import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/screenProvider.dart';
import '../../core/repository/jolpica_repository.dart';
import '../../core/services/jolpica_service.dart';

class StandingsList extends ConsumerWidget {
  final String type; //Assume i valori "drivers" o "constructors" per capire cosa mostrare.
  StandingsList({super.key, required this.type});

  final F1Repository _repository = F1Repository(ApiService());

  @override
  Widget build(BuildContext context, WidgetRef sRef) {
    final sizeScreen = sRef.watch(screenProvider);

    return FutureBuilder<List<dynamic>>(
      future: type == "drivers"
          ? _repository.fetchDriversStandings()
          : _repository.fetchTeamsStandings(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        } else if (snapshot.hasError) {
          return Text("Errore nel recuper della classifica: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Nessun dato disponibile!");
        }

        final data = snapshot.data!;
        return Container(
          color: Colors.black,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Classifica ${DateTime.now().year}",
                    style: TextStyle(
                      fontSize: sizeScreen.isSmallPhone ? 20 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                SingleChildScrollView(
                  child: DataTable(
                    horizontalMargin: sizeScreen.isSmallPhone ? 10 : 20,
                    columns: _buildColumns(sizeScreen.isSmallPhone),
                    rows: _buildRows(data, sizeScreen.isSmallPhone),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildColumns(bool isSmall) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: isSmall ? 13 : 15,
    );

    return [
      DataColumn(label: Text('Pos.', style: style)),
      DataColumn(label: Text(type == "drivers" ? 'Pilota' : 'Team', style: style)),
      DataColumn(label: Text('Naz', style: style)),
      DataColumn(label: Text('Pts', style: style)),
    ];
  }

  List<DataRow> _buildRows(List<dynamic> data, bool isSmall) {
    return List<DataRow>.generate(data.length, (index) {
      final item = data[index];
      final textStyle = TextStyle(
        color: Colors.white,
        fontSize: isSmall ? 12 : 14,
      );

      return DataRow(
        cells: [
          DataCell(Text("${index + 1}°", style: textStyle)),
          DataCell(
            Text(
              type == "drivers" ? item.driver.surname : item.constructor.name,
              style: textStyle.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          DataCell(
            Text(
              type == "drivers"
                  ? item.driver.nationality.substring(0, 3).toUpperCase()
                  : item.constructor.nationality.substring(0, 3).toUpperCase(),
              style: textStyle,
            ),
          ),
          DataCell(Text("${item.points}", style: textStyle)),
        ],
      );
    });
  }
}
