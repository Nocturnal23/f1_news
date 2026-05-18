import 'package:f1_news/core/models/race_details.dart';
import 'package:f1_news/core/providers/screenProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardInfo extends ConsumerWidget {
  final String img;
  final RaceDetailsModel details;

  CardInfo({super.key, required this.img, required this.details});

  @override
  Widget build(BuildContext context, WidgetRef sRef) {
    final sizeScreen = sRef.watch(screenProvider);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: sizeScreen.height * 0.8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(img, fit: BoxFit.contain),
              Padding(
                padding: EdgeInsets.all(sizeScreen.isSmallPhone ? 12.0 : 16.0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: sizeScreen.isSmallPhone ? 1.5 : 1.8,

                      children: [
                        _buildData("Prima edizione", "${details.firstEdition}", sizeScreen.isSmallPhone),
                        _buildData("Ultimo vincitore", "${details.lastWinner}", sizeScreen.isSmallPhone),
                      ],
                    ),


                    SizedBox(height: sizeScreen.isSmallPhone ? 12 : 20),

                    LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: sizeScreen.isSmallPhone ? 1.5 : 1.8,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: [
                              _buildData("Lunghezza", "${details.trackLength} km", sizeScreen.isSmallPhone),

                              _buildData("Giro veloce", "${details.lapRecord}", sizeScreen.isSmallPhone),

                              _buildData("Numero di giri", "${details.lapsNumber}", sizeScreen.isSmallPhone),

                              _buildData("Distanza gara", "${(details.trackLength * details.lapsNumber).toStringAsFixed(3)} km", sizeScreen.isSmallPhone),
                            ],
                          );
                        },
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
        style: TextStyle(
          fontSize: isSmall ? 14 : 16,
        ),
        softWrap: true,
      ),
    ],
  );
}