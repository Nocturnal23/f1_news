import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/championship/constructor.dart';
import '../../core/models/championship/driver_standing.dart';
import '../../core/providers/screen_provider.dart';
import '../../core/utils/country_helper.dart';
import '../../l10n/app_localizations.dart';
import '../common/error_retry.dart';

class CardCompetitor extends ConsumerStatefulWidget {
  final String type;
  dynamic item;
  final String name;
  final dynamic repository;

  CardCompetitor({
    super.key,
    required this.type,
    required this.item,
    required this.name,
    required this.repository,
  });

  @override
  ConsumerState<CardCompetitor> createState() => _CardCompetitorState();
}

class _CardCompetitorState extends ConsumerState<CardCompetitor> {
  dynamic _extraData;
  bool _isLoading = true;
  String? _errorMessage;
  late String _id;
  late String _isoCode;
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _initializeIdentifiers();
    _loadExtraData();
  }

  void _initializeIdentifiers() {
    String nationality = '';
    if (widget.type == "drivers") {
      final driverStanding = widget.item as DriverModelStanding;
      _id = driverStanding.driver.id;
      nationality = driverStanding.driver.nationality;
    } else {
      final constructorItem = widget.item as ConstructorModel;
      _id = constructorItem.id;
      nationality = constructorItem.nationality;
    }
    _isoCode = CountryHelper.getIsoCodeFromNationality(nationality);
  }

  Future<void> _loadExtraData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await widget.repository.fetchCompetitorExtra(widget.type, _id);
      if (mounted) {
        setState(() {
          _extraData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = ref.watch(screenProvider);

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
                  child: _isoCode.isNotEmpty
                      ? CountryFlag.fromCountryCode(_isoCode)
                      : Container(color: Colors.grey.shade800),
                ),
              ),

              //Immagine pilota o vettura.
              if (_errorMessage == null)
                Positioned(
                  child: Image.asset(
                    widget.type == "drivers"
                        ? "lib/assets/drivers/$_id.webp"
                        : "lib/assets/teams/$_id.webp",
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
                  child: _buildContent(screen)
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ScreenProvider screen) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.red),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: SingleChildScrollView(
          child: ErrorRetry(
            errorMessage: _errorMessage!,
            onRetry: _loadExtraData,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _extraData?.name ?? widget.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        DefaultTabController(
          length: widget.type == 'drivers' ? 3 : 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Pagina 1: Anagrafica
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 16.0,
                          runSpacing: 4.0,
                          children: [
                            _buildInfoChip(
                              icon: Icons.location_on_outlined,
                              text: widget.type == "drivers"
                                  ? "${l10n.born} ${_extraData?.birthDate}"
                                  : "${_extraData?.base}, ${_extraData?.country}",
                            ),
                            _buildInfoChip(
                              icon: Icons.calendar_today_outlined,
                              text: "${l10n.debut}: ${_extraData?.debut}",
                            ),
                          ],
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 16.0,
                          runSpacing: 4.0,
                          children: [
                            _buildInfoChip(
                              icon: Icons.flag_outlined,
                              text: "${l10n.grandPrixEntered}: ${_extraData?.gpDisputed}",
                            ),
                            _buildInfoChip(
                              icon: Icons.emoji_events_outlined,
                              text: (_extraData?.gpWin ?? 0) > 0
                                  ? "${l10n.gpWin}: ${_extraData?.gpWin}"
                                  : "${l10n.bestResult}: ${_extraData?.bestResult}",
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
                            text: widget.type == 'drivers'
                                ? "${l10n.title}: ${_extraData?.wdc}"
                                : "${l10n.title}: ${_extraData?.wdcConstructor ?? 0} (${l10n.constructorType}) / ${_extraData?.wdcDriver ?? 0} (${l10n.driverType})",
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.type == "drivers") ...[
                          _buildInfoChip(
                            icon: Icons.history,
                            text: "${l10n.driverHistory}: ${_extraData?.teams?.join(', ') ?? 'N/A'}",
                          ),
                        ] else ...[
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 4.0,
                            children: [
                              _buildInfoChip(
                                icon: Icons.person_outline,
                                text: "${l10n.teamPrincipal}: ${_extraData?.teamChief?.join(', ') ?? 'N/A'}",
                              ),
                              _buildInfoChip(
                                icon: Icons.engineering_outlined,
                                text: "${l10n.teamTechnicalDirector}: ${_extraData?.technicalChief?.join(', ') ?? 'N/A'}",
                              ),
                              Visibility(
                                visible: _extraData?.reserveDriver?.isNotEmpty == true,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: _buildInfoChip(
                                  icon: Icons.person,
                                  text: "${l10n.reserveDriver}: ${_extraData?.reserveDriver?.join(', ') ?? 'N/A'}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),

                    if (widget.type == 'constructors')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 4.0,
                            children: [
                              _buildInfoChip(
                                icon: Icons.directions_car_outlined,
                                text: "${l10n.chassis}: ${_extraData?.chassis ?? 'N/A'}",
                              ),
                              _buildInfoChip(
                                icon: Icons.settings_suggest_outlined,
                                text: "${l10n.powerUnit}: ${_extraData?.powerUnit ?? 'N/A'}",
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
    if (widget.type == 'drivers' && (_extraData?.wdc ?? 0) > 0) return true;
    if (widget.type == 'constructors' && ((_extraData?.wdcDriver ?? 0) > 0 || (_extraData?.wdcConstructor ?? 0) > 0)) return true;
    return false;
  }
}
