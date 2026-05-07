import 'package:f1_news/core/models/race_details_model.dart';
import 'package:flutter/material.dart';

class CardInfo extends StatelessWidget {
  final String img;
  final RaceDetailsModel details;

  CardInfo({super.key, required this.img, required this.details});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(img, fit: BoxFit.contain),
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildData(
                    "Lunghezza",
                    "${details.trackLength} km",
                    isSmallScreen,
                  ),
        
                  SizedBox(height: isSmallScreen ? 12 : 20),
        
                  LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: isSmallScreen ? 1.5 : 1.8,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          children: [
                            _buildData("Prima edizione", "${details.firstEdition}", isSmallScreen),

                            _buildData("Giro veloce", "${details.lapRecord}", isSmallScreen),

                            _buildData("Numero di giri", "${details.lapsNumber}", isSmallScreen),

                            _buildData("Distanza gara", "${(details.trackLength * details.lapsNumber).toStringAsFixed(3)} km", isSmallScreen),
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
