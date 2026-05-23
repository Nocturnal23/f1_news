class DriverDetails {
  final String debut;
  final String bestResult;
  final int gpDisputed;
  final int gpStart;
  final int gpWin;
  final int podium;
  final double totalPoints;
  final int polePosition;
  final int fastestLap;
  final int wdc;
  final List<String> teams;

  DriverDetails({
    required this.debut,
    required this.bestResult,
    required this.gpDisputed,
    required this.gpStart,
    required this.gpWin,
    required this.podium,
    required this.totalPoints,
    required this.polePosition,
    required this.fastestLap,
    required this.wdc,
    required this.teams
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json){
    return DriverDetails(
      debut: json['debut'] ?? 'TBC',
      bestResult: json['bestResult'] ?? 'TBC',
      gpDisputed: json['gpDisputed'] ?? 0,
      gpStart: json['gpStart'] ?? 0,
      gpWin: json['gpWin'] ?? 0,
      podium: json['podium'] ?? 0,
      totalPoints: (json['totalPoints'] ?? 0).toDouble(),
      polePosition: json['polePosition'] ?? 0,
      fastestLap: json['fastestLap'] ?? 0,
      wdc: json['wdc'] ?? 0,
      /*
      IMPORTANTE PERCHE' DART E' SCEMO!
      Dynamic dice che il tipo di dato può essere qualsiasi cosa.

      Quando questa funzione vede che arriva una lista crea una List<dynamic>,
      una lista che può contenere qualsiasi cosa, {"Serra", 1, true"} a lui va bene.

      Ma arriva una lista di sole stringhe e a Dart sta cosa non piace poichè
      esige una lista mista.

      List<String>.from -> Assicura di prendere i dati e "salvarli" nella lista di stringhe.
      */
      teams: List<String>.from(json['teams'] ?? []),
    );
  }
}