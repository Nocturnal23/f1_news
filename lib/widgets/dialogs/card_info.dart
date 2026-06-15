import 'package:f1_news/core/models/championship/race_details.dart';
import 'package:f1_news/core/providers/screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../common/error_retry.dart';

class CardInfo extends ConsumerStatefulWidget {
  final String img;
  final String circuitId;
  final dynamic repository;

  const CardInfo({
    super.key,
    required this.img,
    required this.circuitId,
    required this.repository,
  });

  @override
  ConsumerState<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends ConsumerState<CardInfo> {
  RaceDetailsModel? _details;
  bool _isLoading = true;
  String? _errorMessage;
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await widget.repository.fetchRaceDetails(widget.circuitId);
      if (mounted) {
        setState(() {
          _details = data;
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
    final sizeScreen = ref.watch(screenProvider);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: sizeScreen.height * 0.8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(widget.img, fit: BoxFit.contain),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ErrorRetry(
                    errorMessage: _errorMessage!,
                    onRetry: _loadData,
                  ),
                )
              else if (_details != null)
                Padding(
                  padding: EdgeInsets.all(
                    sizeScreen.isSmallPhone ? 12.0 : 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: sizeScreen.isSmallPhone ? 1.5 : 1.8,
                        children: [
                          _buildData(
                            l10n.firstEdition,
                            _details!.firstEdition,
                            sizeScreen.isSmallPhone,
                          ),
                          _buildData(
                            l10n.lastWinner,
                            _details!.lastWinner,
                            sizeScreen.isSmallPhone,
                          ),
                        ],
                      ),

                      SizedBox(height: sizeScreen.isSmallPhone ? 12 : 20),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: sizeScreen.isSmallPhone ? 1.5 : 1.8,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          _buildData(
                            l10n.length,
                            "${_details!.trackLength} km",
                            sizeScreen.isSmallPhone,
                          ),
                          _buildData(
                            l10n.lapRecord,
                            _details!.lapRecord,
                            sizeScreen.isSmallPhone,
                          ),
                          _buildData(
                            l10n.laps,
                            "${_details!.lapsNumber}",
                            sizeScreen.isSmallPhone,
                          ),
                          _buildData(
                            l10n.raceDistance,
                            "${(_details!.trackLength * _details!.lapsNumber).toStringAsFixed(3)} km",
                            sizeScreen.isSmallPhone,
                          ),
                        ],
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

Widget _buildData(String title, String subtitle, bool isSmall) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: isSmall ? 18 : 20,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 2),

      Text(
        subtitle,
        style: TextStyle(fontSize: isSmall ? 14 : 16),
        softWrap: true,
      ),
    ],
  );
}
