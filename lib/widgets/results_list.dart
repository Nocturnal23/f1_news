import 'package:f1_news/core/models/sessions/race_result.dart';
import 'package:f1_news/core/utils/session_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/sessions/base_result.dart';

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
    final result = sessionName.getResults(ref, round);

    return result.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
      error: (err, stack) => Center(child: Text("Errore: $err")),
      data: (results) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sessionName.displayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(child: _buildStanding(results)),
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
  Widget _buildStanding(List<BaseResultModel> results) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 16,
            columns: sessionName.headers
                .map((h) => DataColumn(label: Text(h, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))))
                .toList(),
            rows: results.map((res) {
              return DataRow(
                cells: [
                  DataCell(Text(res.displayPosition)),
                  DataCell(Text(res.driver.surname)),
                  DataCell(Text(res.driver.nationality.substring(0, 3).toUpperCase())),
                  DataCell(Text(res.constructor.name)),
                  ...res.extraColumns.map((e) => DataCell(Text(e))),
                ],
              );
            }).toList(),
          ),
        ),
        if (sessionName.hasFastestLap && results.isNotEmpty)
          _buildFastestLap(results.cast<RaceResultModel>())
      ],
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
