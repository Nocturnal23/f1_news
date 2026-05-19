import 'package:country_flags/country_flags.dart';
import 'package:f1_news/widgets/dialogs/card_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/screenProvider.dart';
import '../../core/utils/country_helper.dart';
import '../../core/providers/provider.dart';
import '../dialogs/event_info.dart';

class CardCustom extends ConsumerWidget {
  dynamic item;

  CardCustom({super.key, this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.watch(screenProvider);
    final String isoCode = CountryHelper.getIsoCode(item.country);

    return SizedBox(
      height: screen.isSmallPhone ? 180 : 220,
      width: double.infinity,
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: isoCode.isNotEmpty
                    ? CountryFlag.fromCountryCode(isoCode, theme: ImageTheme())
                    : Container(color: Colors.grey),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if(context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => EventInfo(raceModel: item)
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              item.raceName ?? "Grand Prix",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screen.isSmallPhone ? 18 : 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "${item.fp1Date} - ${item.date}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    child: Image.asset(
                      "lib/assets/circuits/${item.circuitName}.webp",
                      fit: BoxFit.contain,
                      height: screen.isSmallPhone ? 80 : 120,
                    ),
                    onTap: () async {
                      final repository = ref.read(f1RepositoryProvider);
                      final details = await repository.fetchRaceDetails(item.circuitId);

                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => CardInfo(
                            img: "lib/assets/circuits/${item.circuitName}.webp",
                            details: details,
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
