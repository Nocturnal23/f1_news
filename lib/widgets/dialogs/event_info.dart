import 'package:f1_news/widgets/dialogs/results_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/championship/race.dart';
import '../../core/providers/screen_provider.dart';
import '../../core/utils/session_type.dart';
import '../../l10n/app_localizations.dart';

class EventInfo extends ConsumerWidget {
  final RaceModel raceModel;

  const EventInfo({super.key, required this.raceModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.watch(screenProvider);
    final todayDate = DateTime.now();
    final l10n = AppLocalizations.of(context)!;
    final localeName = l10n.localeName;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                raceModel.raceName,
                style: TextStyle(
                    fontSize: screen.isSmallPhone ? 18 : 20,
                    fontWeight: FontWeight.bold
                ),
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
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                },
                children: raceModel.weekendSessions.map((session) {
                  final SessionType type = session['type'];
                  final String sessionName = type == SessionType.unknown
                      ? session['defaultName']
                      : type.getDisplayName(l10n);

                  final sessionDateTime = DateTime.parse(
                    "${session['date']}T${session['time']}",
                  );
                  final bool isPast = todayDate.isAfter(sessionDateTime);
                  final String displayDate = DateFormat.Md(localeName)
                      .add_jm()
                      .format(sessionDateTime.toLocal());

                  return TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: screen.isSmallPhone ? 8.0 : 13.0),
                        child: Text(
                          sessionName,
                          style: TextStyle(fontSize: screen.isSmallPhone ? 13 : 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: screen.isSmallPhone ? 8.0 : 13.0),
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
                                    child: Text(
                                      l10n.eventInfoResult,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              )
                            : Text(isPast ? l10n.eventInfoEnded : displayDate),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.windowClose),
              ),
            ],
          ),
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
