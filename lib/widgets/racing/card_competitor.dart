import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/championship/constructor.dart';
import '../../core/models/championship/driver_standing.dart';
import '../../core/providers/screen_provider.dart';
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
                      extraData?.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),

                    //Controller pagine scorrevoli.
                    DefaultTabController(
                      length: type == 'drivers' ? 3 : 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 100,
                            child: TabBarView(
                              physics: const BouncingScrollPhysics(),
                              children: [

                                //Prima pagina. Anagrafica.
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 16.0,
                                      runSpacing: 4.0,
                                      children: [
                                        _buildInfoChip(
                                          icon: Icons.location_on_outlined,
                                          text: type == "drivers"
                                              ? "Nato il ${extraData?.birthDate}"
                                              : "${extraData?.base}, ${extraData?.country}",
                                        ),
                                        _buildInfoChip(
                                          icon: Icons.calendar_today_outlined,
                                          text: "Debutto: ${extraData?.debut}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                //Seconda pagina. Statistiche.
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 16.0,
                                      runSpacing: 4.0,
                                      children: [
                                        _buildInfoChip(
                                          icon: Icons.flag_outlined,
                                          text: "GP Totali: ${extraData?.gpDisputed}",
                                        ),
                                        _buildInfoChip(
                                          icon: Icons.emoji_events_outlined,
                                          text: extraData?.gpWin > 0
                                              ? "GP Vinti: ${extraData?.gpWin}"
                                              : "Miglior risultato: ${extraData?.bestResult}",
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: _hasTitles(),
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: _buildInfoChip(
                                        icon: Icons.star_border,
                                        text: type == 'drivers'
                                            ? "Titoli: ${extraData?.wdc}"
                                            : "Titoli: ${extraData?.wdcConstructor ?? 0} (C) / ${extraData?.wdcDriver ?? 0} (P)",
                                      ),
                                    ),
                                  ],
                                ),

                                //Pagiga 3) Storico team piloti o organico costruttori.
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (type == "drivers") ...[
                                      _buildInfoChip(
                                        icon: Icons.history,
                                        text: "Storico team: ${extraData?.teams.join(', ')}",
                                      ),
                                    ] else ...[
                                      Wrap(
                                        spacing: 16.0,
                                        runSpacing: 4.0,
                                        children: [
                                          _buildInfoChip(
                                            icon: Icons.person_outline,
                                            text: "TP: ${extraData?.teamChief?.join(', ') ?? 'N/A'}",
                                          ),
                                          _buildInfoChip(
                                            icon: Icons.engineering_outlined,
                                            text: "TD: ${extraData?.technicalChief?.join(', ') ?? 'N/A'}",
                                          ),
                                          Visibility(
                                            visible: extraData?.reserveDriver.isNotEmpty,
                                            maintainSize: true,
                                            maintainAnimation: true,
                                            maintainState: true,
                                            child: _buildInfoChip(
                                              icon: Icons.person,
                                              text: "Riserve: ${extraData?.reserveDriver?.join(', ') ?? 'N/A'}",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),

                                //Pagina 4) Dettagli vettura.
                                if (type == 'constructors')
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: 16.0,
                                        runSpacing: 4.0,
                                        children: [
                                          _buildInfoChip(
                                            icon: Icons.directions_car_outlined,
                                            text: "Telaio: ${extraData?.chassis ?? 'N/A'}",
                                          ),
                                          _buildInfoChip(
                                            icon: Icons.settings_suggest_outlined,
                                            text: "PU: ${extraData?.powerUnit ?? 'N/A'}",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),
                          const Center(
                            child: TabPageSelector(
                              color: Colors.white24,
                              selectedColor: Colors.white,
                              indicatorSize: 8,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    Color iconColor = Colors.white70,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(icon, size: 14, color: iconColor),
          ),
          const WidgetSpan(child: SizedBox(width: 4)),
          TextSpan(
            text: text,
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }

  bool _hasTitles() {
    if (type == 'drivers' && (extraData?.wdc ?? 0) > 0) return true;
    if (type == 'constructors' &&
        ((extraData?.wdcDriver ?? 0) > 0 ||
            (extraData?.wdcConstructor ?? 0) > 0))
      return true;
    return false;
  }
}
