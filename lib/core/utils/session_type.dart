import 'package:f1_news/core/providers/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sessions/base_result.dart';

enum SessionType {
  sprintQualifying,
  sprintRace,
  qualifying,
  race,
  unknown,
}

extension SessionTypeExtension on SessionType {
  String get displayName {
    switch (this) {
      case SessionType.sprintQualifying: return "Sprint Qualifying";
      case SessionType.sprintRace: return "Sprint Race";
      case SessionType.qualifying: return "Qualifying";
      case SessionType.race: return "Race";
      default: return "Free Practice";
    }
  }

  bool get hasResults => this != SessionType.unknown;

  List<String> get headers {
    switch (this) {
      case SessionType.qualifying:
        return ["Pos", "Pilota", "Naz", "Team", "Q1", "Q2", "Q3"];

      case SessionType.sprintRace:
      case SessionType.race:
        return ["Pos", "Pilota", "Naz", "Team", "Tempo", "Pts"];

      case SessionType.sprintQualifying:
        return ["Pos", "Pilota", "Naz", "Team"];

      default:
        return ["Pos", "Pilota", "Naz", "Team"];
    }
  }

  bool get hasFastestLap {
    return this == SessionType.race || this == SessionType.sprintRace;
  }

  AsyncValue getResults(WidgetRef ref, String round) {
    switch (this) {
      case SessionType.sprintQualifying:
        return ref.watch(sprintGridProvider(round));

      case SessionType.qualifying:
        return ref.watch(qualiResultsProvider(round));

      case SessionType.sprintRace:
        return ref.watch(sprintResultsProvider(round));

      case SessionType.race:
        return ref.watch(raceResultsProvider(round));

      default:
        return const AsyncValue.data([]);
    }
  }
}