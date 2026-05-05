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

