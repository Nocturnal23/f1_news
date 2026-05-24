import 'package:f1_news/core/models/sessions/race_result.dart';
import 'package:f1_news/core/utils/session_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/sessions/base_result.dart';
import '../../core/providers/screen_provider.dart';
import '../common/error_retry.dart';

class ResultsList extends ConsumerWidget {
  final SessionType sessionName; //Identifica la sessione (Sprint Quali, Sprint, Gara..)
  final String round;

  const ResultsList({
    super.key,
    required this.sessionName,
    required this.round,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = sessionName.getResultsProvider(round);
    final result = ref.watch(provider);
    final screen = ref.watch(screenProvider);

    return result.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
      error: (err, stack) => ErrorRetry(
        errorMessage: err.toString(),
        onRetry: () => ref.invalidate(provider),
      ),
      data: (results) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sessionName.displayName,
              style: TextStyle(
                fontSize: screen.isTablet ? 24 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                child: _buildStanding(results, screen),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Chiudi"),
            ),
          ],
        ),
      ),
    );
  }

  //Se è qualifica: grid, nome, nazion, team, (se è qualifica normale mostrare Q1, Q2, Q3)
  //Se è gara/sprint: pos, nome, nazion, team, punti, tempo. In fondo alla lista mostra giro veloce.
  Widget _buildStanding(List<BaseResultModel> results, ScreenProvider screen) {
    final Widget tableWidget = _buildTable(results, screen);

    if (results.isEmpty) {
      return _waitingResults(screen);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: tableWidget,
          ),

        if (sessionName.hasFastestLap && results.isNotEmpty)
          _buildFastestLap(results.cast<RaceResultModel>()),
      ],
    );
  }

  Widget _waitingResults(ScreenProvider screen) {
    return Center(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule,
                size: screen.isTablet ? 56 : 42,
                color: Colors.orange,
              ),

              const SizedBox(height: 16),

              Text(
                "Risultati non ancora disponibili",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screen.isTablet ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "I risultati della sessione verranno pubblicati appena disponibili.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screen.isTablet ? 16 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable(List<BaseResultModel> results, ScreenProvider screen) {
    final headerStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: screen.isTablet ? 16 : 13,
    );
    final cellStyle = TextStyle(fontSize: screen.isTablet ? 15 : 14);

    return DataTable(
      columnSpacing: screen.isTablet ? 32 : 16,
      horizontalMargin: screen.isTablet ? 24 : 12,
      dataRowMinHeight: screen.isTablet ? 55 : 48,
      dataRowMaxHeight: screen.isTablet ? 60 : 52,
      columns: sessionName.headers
          .map((h) => DataColumn(label: Text(h, style: headerStyle)))
          .toList(),
      rows: results.map((res) {
        return DataRow(
          cells: [
            DataCell(
              Text(
                res.displayPosition,
                style: cellStyle.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            DataCell(Text(res.driver.surname, style: cellStyle)),
            DataCell(
              Text(
                res.driver.nationality.substring(0, 3).toUpperCase(),
                style: cellStyle,
              ),
            ),
            DataCell(Text(res.constructor.name, style: cellStyle)),
            ...res.extraColumns.map((e) => DataCell(Text(e, style: cellStyle))),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildFastestLap(List<RaceResultModel> results) {
    try {
      final fastest = results.firstWhere((res) => res.fastestLapRank == "1");

      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Giro Veloce:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${fastest.driver.surname} - ${fastest.fastestLapTime}"),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }
}
