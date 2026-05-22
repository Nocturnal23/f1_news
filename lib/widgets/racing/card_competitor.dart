import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/championship/constructor.dart';
import '../../core/models/championship/driver_standing.dart';
import '../../core/providers/screenProvider.dart';
import '../../core/utils/country_helper.dart';

class CardCompetitor extends ConsumerWidget {
  final String type;
  dynamic item;
  final String name;
  CardCompetitor({super.key, required this.type, required this.item, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.watch(screenProvider);
    String id = '';
    String nationality = '';
    if (type == "drivers") {
      final driverStanding = item as DriverModelStanding;
      id = driverStanding.driver.id;
      nationality = driverStanding.driver.nationality;
    } else {
      final constructorItem = item as ConstructorModel;
      id = constructorItem.id;
      nationality = constructorItem.nationality;
    }
    final String isoCode = CountryHelper.getIsoCodeFromNationality(nationality);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: screen.isSmallPhone ? 220 : 260,
        width: double.infinity,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Stack(
            children: [
              //Bandiera
              Positioned.fill(
                child: Opacity(
                  opacity: 0.6,
                  child: nationality != ""
                      ? CountryFlag.fromCountryCode(
                    isoCode,
                  )
                      : Container(color: Colors.grey.shade800),
                ),
              ),

              //Immagine pilota o vettura.
              Positioned(
                child: Image.asset(
                  type == "drivers"
                      ? "lib/assets/drivers/$id.webp"
                      : "lib/assets/teams/$id.webp",
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),

              //Testi
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.9),
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dettagli ${type == 'drivers' ? 'Pilota' : 'Costruttore'}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        "ID: $id",
                        style: const TextStyle(color: Colors.white70, fontSize: 13)
                    ),
                    Text(
                        "Nazionalità: $nationality",
                        style: const TextStyle(color: Colors.white70, fontSize: 13)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
