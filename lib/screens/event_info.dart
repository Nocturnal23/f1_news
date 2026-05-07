import 'package:f1_news/widgets/results_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../core/models/race.dart';
import '../core/utils/session_type.dart';

class EventInfo extends ConsumerWidget {
  final RaceModel raceModel;

  const EventInfo({super.key, required this.raceModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayDate = DateTime.now();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              raceModel.raceName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${raceModel.locality}, ${raceModel.country}",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 24),

            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(2),
              },
              children: raceModel.weekendSessions.map((session) {
                final SessionType type = session['type'];
                final String sessionName = type == SessionType.unknown
                    ? session['defaultName']
                    : type.displayName;

                final sessionDateTime = DateTime.parse(
                  "${session['date']}T${session['time']}",
                );
                final bool isPast = todayDate.isAfter(sessionDateTime);
                final String displayDate = DateFormat(
                  'dd/MM HH:mm',
                ).format(sessionDateTime.toLocal());

                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        sessionName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: isPast && type.hasResults
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () => _openResultsDialog(
                                    context,
                                    raceModel.round,
                                    type,
                                  ),
                                  child: const Text(
                                    "Risultati",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            )
                          : Text(isPast ? "Concluso" : displayDate),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Chiudi"),
            ),
          ],
        ),
      ),
    );
  }

  void _openResultsDialog(BuildContext context, String round, SessionType type) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (context) =>
          ResultsList(sessionName: type, round: round),
    );
  }
}
