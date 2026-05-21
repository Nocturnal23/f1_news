import '../../utils/session_type.dart';

class RaceModel {
  final String round;
  final String raceName; //Es. Monaco Grand Prix
  final String date; //Formato YYYY-MM-GG.
  final String time;

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
    required this.time,

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

  // Getter per l'inizio della gara
  DateTime get raceStartDateTime {
    try {
      return DateTime.parse("${date}T$time").toLocal();
    } catch (e) {
      return DateTime.parse(date).toLocal();
    }
  }

  // Getter per l'inizio delle FP1
  DateTime get fp1StartDateTime {
    try {
      return DateTime.parse("${fp1Date}T$fp1Time").toLocal();
    } catch (e) {
      return DateTime.parse(fp1Date).toLocal();
    }
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
      time: json['time'] ?? 'N/A',

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

extension RaceSessions on RaceModel {
  List<Map<String, dynamic>> get weekendSessions {
    List<Map<String, dynamic>> sessions = [];

    void addSession(SessionType type, String date, String time, String defaultName) {
      if (date != 'N/A' && time != 'N/A') {
        sessions.add({
          'type': type,
          'date': date,
          'time': time,
          'defaultName': defaultName,
        });
      }
    }

    addSession(SessionType.unknown, fp1Date, fp1Time, "FP1");

    if (sprintDate != 'N/A') {
      addSession(SessionType.sprintQualifying, sprintQualiDate, sprintQualiTime, "Sprint Qualifying");
      addSession(SessionType.sprintRace, sprintDate, sprintTime, "Sprint Race");
    } else {
      addSession(SessionType.unknown, fp2Date, fp2Time, "FP2");
      addSession(SessionType.unknown, fp3Date, fp3Time, "FP3");
    }

    addSession(SessionType.qualifying, qualiDate, qualiTime, "Qualifying");
    addSession(SessionType.race, date, time, "Race");

    return sessions;
  }
}