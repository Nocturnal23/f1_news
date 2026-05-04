import 'package:f1_news/core/models/sessions/race_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/utils/provider.dart';

class ResultsList extends ConsumerWidget {
  final String sessionName; //Identifica la sessione (Sprint Quali, Sprint, Gara..)
  final String round;

  const ResultsList({
    super.key,
    required this.sessionName,
    required this.round,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = sessionName.contains("Qualifying")
        ? ref.watch(sprintGridProvider(round))
        : ref.watch(sprintResultsProvider(round));

    return result.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.red)),
      error: (err, stack) => Center(child: Text("Errore: $err")),
      data: (results) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sessionName,
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
  Widget _buildStanding(List<RaceResultModel> results) {
    final bool isQualy = sessionName.contains("Qualifying");
    final bool isSprintQualy = sessionName.contains("Sprint Qualifying");
    final bool isStandardQualy = isQualy && !isSprintQualy;

    return Column(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: {
            0: const FlexColumnWidth(0.8),
            1: const FlexColumnWidth(2.2),
            2: const FlexColumnWidth(1.0),
            3: const FlexColumnWidth(2.5),
            if (!isQualy) 4: const FlexColumnWidth(0.8),
            if (!isQualy) 5: const FlexColumnWidth(2.0),
          },
          children: [
            TableRow(
              children: [
                _headerText("Pos", isHeader: true),
                _headerText("Pilota", isHeader: true),
                _headerText("Naz", isHeader: true),
                _headerText("Team", isHeader: true),
                if (!isQualy) _headerText("Pts", isHeader: true),
                if (!isQualy) _headerText("Tempo", isHeader: true),
              ],
            ),
            ...results.map(
              (res) => TableRow(
                children: [
                  _headerText(isQualy ? res.grid : res.position),
                  _headerText(res.driver.surname),
                  _headerText(res.driver.nationality.substring(0, 3).toUpperCase()),
                  _headerText(res.constructor.name),
                  if (!isQualy) _headerText(res.points),
                  if (!isQualy) _headerText(res.totalTime == 'N/A' ? res.status : res.totalTime),
                ],
              ),
            ),
          ],
        ),
        if (!isQualy) _buildFastestLap(results),
      ],
    );
  }

  Widget _headerText(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: isHeader ? 13 : 14,
        ),
        overflow: TextOverflow.ellipsis,
      ),
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
