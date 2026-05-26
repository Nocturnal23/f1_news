class DriverDetails {
  final String name;
  final String birthDate;
  final String debut;
  final List<String> teams;
  final int gpDisputed;
  final int podium;
  final int gpWin;
  final String bestResult;
  final int polePosition;
  final double totalPoints;
  final int wdc;

  DriverDetails({
    required this.name,
    required this.birthDate,
    required this.debut,
    required this.teams,
    required this.gpDisputed,
    required this.podium,
    required this.gpWin,
    required this.bestResult,
    required this.polePosition,
    required this.totalPoints,
    required this.wdc,
  });

  factory DriverDetails.fromJson(Map<String, dynamic> json){
    return DriverDetails(
      name: json['nome'] ?? 'F1_Driver',
      birthDate: json['dataDiNascita'] ?? 'Date',
      debut: json['debut'] ?? 'TBC',
      gpDisputed: json['gpDisputed'] ?? 0,
      podium: json['podium'] ?? 0,
      gpWin: json['gpWin'] ?? 0,
      bestResult: json['bestResult'] ?? 'TBC',
      polePosition: json['polePosition'] ?? 0,
      totalPoints: (json['totalPoints'] ?? 0).toDouble(),
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