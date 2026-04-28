class RaceModel {
  final String round;
  final String raceName; //Es. Monaco Grand Prix
  final String date; //Formato YYYY-MM-GG.

  // I seguenti 2 campi appartengono all'oggetto Circut
  final String circuitId;
  final String circuitName; //Es. Circuit de Monaco
  // Questi altri due sono dell'oggetto Locality in Circuit.
  final String locality; // Es. Monte-Carlo
  final String country; // Es. Monaco

  //I seguenti campi sono degli oggetti relati alle sessioni da cui estraggo la data della sesisione.
  final String fp1Date;
  final String fp1Time;
  final String fp2Date;
  final String fp2Time;
  final String fp3Date;
  final String fp3Time;
  final String qualiDate;
  final String qualiTime;
  final String sprintQualiDate;
  final String sprintQualiTime;
  final String sprintDate;
  final String sprintTime;

  RaceModel({
    required this.round,
    required this.raceName,
    required this.date,

    required this.circuitId,
    required this.circuitName,
    required this.locality,
    required this.country,

    required this.fp1Date,
    required this.fp1Time,
    required this.fp2Date,
    required this.fp2Time,
    required this.fp3Date,
    required this.fp3Time,
    required this.qualiDate,
    required this.qualiTime,
    required this.sprintQualiDate,
    required this.sprintQualiTime,
    required this.sprintDate,
    required this.sprintTime,
  });

  String getEventRange() {
    String fp1Day = fp1Date.split("-").last;
    String raceDay = date.split("-").last;

    return "$fp1Day - $raceDay";
  }

  factory RaceModel.fromJson(Map<String, dynamic> json) {
    final circuit = json['Circuit'] ?? {};
    final location = circuit['Location'] ?? {};

    //Estraei i campi date e time dagli oggetti relativi alle sessioni.
    String getSessionData(Map<String, dynamic>? session, String key) {
      return session?[key] ?? 'N/A';
    }

    return RaceModel(
      round: json['round'] ?? 'N/A',
      raceName: json['raceName'] ?? 'N/A',
      date: json['date'] ?? 'N/A',

      circuitId: circuit['circuitId'] ?? 'N/A',
      circuitName: circuit['circuitName'] ?? 'N/A',
      locality: location['locality'] ?? 'NA',
      country: location['country'] ?? 'N/A',

      fp1Date: getSessionData(json['FirstPractice'], 'date'),
      fp1Time: getSessionData(json['FirstPractice'], 'time'),

      fp2Date: getSessionData(json['SecondPractice'], 'date'),
      fp2Time: getSessionData(json['SecondPractice'], 'time'),

      fp3Date: getSessionData(json['ThirdPractice'], 'date'),
      fp3Time: getSessionData(json['ThirdPractice'], 'time'),

      qualiDate: getSessionData(json['Qualifying'], 'date'),
      qualiTime: getSessionData(json['Qualifying'], 'time'),

      sprintQualiDate: getSessionData(
        json['SprintQualifying'] ?? json['SprintShootout'],
        'date',
      ),
      sprintQualiTime: getSessionData(
        json['SprintQualifying'] ?? json['SprintShootout'],
        'time',
      ),

      sprintDate: getSessionData(json['Sprint'], 'date'),
      sprintTime: getSessionData(json['Sprint'], 'time'),
    );
  }
}
