import 'package:f1_news/core/providers/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../l10n/app_localizations.dart';

enum SessionType {
  sprintQualifying,
  sprintRace,
  qualifying,
  race,
  unknown,
}

extension SessionTypeExtension on SessionType {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case SessionType.sprintQualifying: return l10n.sprintQualifying;
      case SessionType.sprintRace: return l10n.sprintRace;
      case SessionType.qualifying: return l10n.qualifying;
      case SessionType.race: return l10n.race;
      default: return "Free Practice";
    }
  }

  bool get hasResults => this != SessionType.unknown;

  List<String> getHeaders(AppLocalizations l10n) {
    final driver = l10n.driver;
    final nationality = l10n.nationality;
    final time = l10n.time;

    switch (this) {
      case SessionType.qualifying:
        return ["Pos", driver, nationality, "Team", "Q1", "Q2", "Q3"];

      case SessionType.sprintRace:
      case SessionType.race:
        return ["Pos", driver, nationality, "Team", time, "Pts"];

      case SessionType.sprintQualifying:
        return ["Pos", driver, nationality, "Team"];

      default:
        return ["Pos", driver, nationality, "Team"];
    }
  }

  bool get hasFastestLap {
    return this == SessionType.race || this == SessionType.sprintRace;
  }

  ProviderBase<AsyncValue> getResultsProvider(String round) {
    switch (this) {
      case SessionType.sprintQualifying: return sprintGridProvider(round);
      case SessionType.qualifying: return qualiResultsProvider(round);
      case SessionType.sprintRace: return sprintResultsProvider(round);
      case SessionType.race: return raceResultsProvider(round);

      default: return Provider((_) => const AsyncValue.data([]));
    }
  }
}