import 'package:f1_news/core/models/race_details_model.dart';
import 'package:flutter/material.dart';

import '../core/repository/jolpica_repository.dart';
import '../core/services/jolpica_service.dart';

class CardInfo extends StatelessWidget {
  final String img;
  final RaceDetailsModel details;

  CardInfo({
    super.key,
    required this.img, required this.details,
  });

  // final F1Repository _repository = F1Repository(ApiService());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(img, fit: BoxFit.contain),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("Prima edizione: ${details.firstEdition}")),
                    Expanded(child: Text("Ultimo vincitore: ${details.lastWinner}")),
                  ]
                ),

                const SizedBox(height: 8),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
