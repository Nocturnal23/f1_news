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
  dynamic extraData;
  final String name;

  CardCompetitor({
    super.key,
    required this.type,
    required this.item,
    required this.name,
    required this.extraData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.watch(screenProvider);
    String id = '';
    String nationality = '';
    String birthdate = '';
    if (type == "drivers") {
      final driverStanding = item as DriverModelStanding;
      id = driverStanding.driver.id;
      nationality = driverStanding.driver.nationality;
      birthdate = driverStanding.driver.dateOfBirth;
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
        height: screen.isSmallPhone ? 260 : 300,
        width: double.infinity,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Stack(
            children: [
              //Bandiera
              Positioned.fill(
                child: Opacity(
                  opacity: 0.6,
                  child: nationality != ""
                      ? CountryFlag.fromCountryCode(isoCode)
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
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
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
                        Colors.transparent,
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
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 4.0,
                      children: [
                        _buildInfoChip(
                          icon: Icons.location_on_outlined,
                          text: type == 'drivers'
                              ? "Nato il: $birthdate"
                              : "${extraData?.base}, ${extraData?.country}",
                        ),
                        _buildInfoChip(
                          icon: Icons.calendar_today_outlined,
                          text: "Debutto: ${extraData?.debut}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 4.0,
                      children: [
                        _buildInfoChip(
                          icon: Icons.flag_outlined,
                          text: "GP: ${extraData?.gpDisputed ?? 0}",
                        ),
                        _buildInfoChip(
                          icon: Icons.emoji_events_outlined,
                          text: "Vittorie: ${extraData?.gpWin ?? 0}",
                        ),
                        if (type == 'drivers' && (extraData?.wdc ?? 0) > 0)
                          _buildInfoChip(
                            icon: Icons.star_border,
                            text: "WDC: ${extraData?.wdc}",
                            iconColor: Colors.amber,
                          ),
                        if (type == 'constructors')
                          _buildInfoChip(
                            icon: Icons.star_border,
                            text: "Titoli: ${extraData?.wdcConstructor ?? 0} (C) / ${extraData?.wdcDriver ?? 0} (P)",
                            iconColor: Colors.amber,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (type == 'constructors') ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16.0,
                        runSpacing: 4.0,
                        children: [
                          _buildInfoChip(
                            icon: Icons.person_outline,
                            text: "TP: ${extraData?.teamChief ?? 'N/A'}",
                          ),
                          _buildInfoChip(
                            icon: Icons.engineering_outlined,
                            text: "TD: ${extraData?.technicalChief?.join(', ') ?? 'N/A'}", // .join() formats the list nicely!
                          ),
                          _buildInfoChip(
                            icon: Icons.directions_car_outlined,
                            text: "Telaio: ${extraData?.chassis ?? 'N/A'}",
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text, Color iconColor = Colors.white70}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
