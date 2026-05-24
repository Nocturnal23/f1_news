import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/provider.dart';
import '../../core/providers/screen_provider.dart';
import '../common/error_retry.dart';

class StandingsList extends ConsumerWidget {
  final String type; //Assume i valori "drivers" o "constructors" per capire cosa mostrare.
  const StandingsList({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef sRef) {
    final sizeScreen = sRef.watch(screenProvider);

    final standingsAsync = sRef.watch(
        type == "drivers" ? driversStandingsProvider : teamsStandingsProvider
    );


    return standingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
        error: (err, stack) => ErrorRetry(
          errorMessage: err.toString(),
          onRetry: () => sRef.refresh(type == "drivers" ? driversStandingsProvider : teamsStandingsProvider),
        ),
        data: (standings) {
            return SizedBox(
              // color: Colors.black,
              width: double.infinity,
              // height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        type == "drivers" ? 'Classifica Piloti' : 'Classifica Costruttori',
                        style: TextStyle(
                          fontSize: sizeScreen.isSmallPhone ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          // color: Colors.white,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeScreen.isTablet ? 32.0 : 8.0,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: DataTable(
                          horizontalMargin: sizeScreen.isSmallPhone ? 10 : 20,
                          columns: _buildColumns(sizeScreen.isSmallPhone),
                          rows: _buildRows(standings, sizeScreen.isSmallPhone),
                        ),
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
      // color: Colors.white,
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
        // color: Colors.white,
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
