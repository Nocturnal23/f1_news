import 'package:f1_news/core/models/championship/race.dart';
import 'package:f1_news/core/providers/provider.dart';
import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/common/error_retry.dart';
import '../../widgets/racing/card_custom.dart';
import '../../widgets/navigation/app_bar_custom.dart';

class Races extends ConsumerWidget {
  const Races({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendar = ref.watch(calendarProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBarCustom(title: "${l10n.calendar} ${DateTime.now().year}"),

      drawer: const DrawerApp(),

      body: calendar.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.red)),
          error: (err, stack) => ErrorRetry(
            errorMessage: err.toString(),
            onRetry: () => ref.refresh(calendarProvider),
          ),
          data: (races) {
            _precacheImages(context, races);
            return _buildCalendar(races);
          }
      ),
    );
  }

  Widget _buildCalendar(List<RaceModel> races) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 1),
      itemCount: races.length,
      itemBuilder: (context, index) {
        final item = races[index];
        return CardCustom(item: item);
      },
    );
  }

  void _precacheImages(BuildContext context, List<dynamic> data) {
    for (var item in data) {
      if (item.circuitName != null) {
        precacheImage(
          AssetImage("lib/assets/circuits/${item.circuitName}.webp"),
          context,
        );
      }
    }
  }
}
