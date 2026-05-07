class RaceDetailsModel {
  final String firstEdition;
  final String lastWinner;
  final double trackLength;
  final String lapRecord;
  final int lapsNumber;

  RaceDetailsModel({
    required this.firstEdition,
    required this.lastWinner,
    required this.trackLength,
    required this.lapRecord,
    required this.lapsNumber
  });

  factory RaceDetailsModel.fromMultiJson(Map<String, dynamic> data, Map<String, dynamic>? extraData){
    return RaceDetailsModel(
      firstEdition: data['firstEdition'] ?? 'N/A',
      lastWinner: data['lastWinner'] ?? 'N/A',

      trackLength: (extraData?['trackLength'] ?? 0).toDouble(),
      lapRecord: extraData?['lapRecord'] ?? 'N/A',
      lapsNumber: (extraData?['lapsNumber'] ?? 0),
    );
  }
}