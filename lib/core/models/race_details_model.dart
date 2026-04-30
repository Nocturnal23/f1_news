class RaceDetailsModel {
  final String firstEdition;
  final String lastWinner;
  // final String trackLength;
  // final String lapRecord;

  RaceDetailsModel({
    required this.firstEdition,
    required this.lastWinner,
    // required this.trackLength,
    // required this.lapRecord,
  });

  //La struttura della seguente factory è temporanea
  // Dovranno essere aggiunti trackLenght e lapRecord
  // Che provenendo da un diverso JSON dovrà essere
  // riscritto.
  factory RaceDetailsModel.fromMultiJson(Map<String, dynamic> data){
    return RaceDetailsModel(
      firstEdition: data['firstEdition'] ?? 'N/A',
      lastWinner: data['lastWinner'] ?? 'N/A',
    );
  }
}