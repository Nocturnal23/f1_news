import 'package:f1_news/core/utils/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sessions/base_result_model.dart';

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
  bool get hasFastestLap {
    return this == SessionType.race || this == SessionType.sprintRace;
  }
}