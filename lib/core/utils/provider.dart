import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../models/constructor_model.dart';
import '../models/driver_model_standing.dart';
import '../models/race_model.dart';
import '../models/sessions/race_result_model.dart';
import '../models/user_model.dart';
import '../repository/jolpica_repository.dart';
import '../services/jolpica_service.dart';
import '../services/user_service.dart';

/*
Fornisce un'istanza di UserService a tutta l'app.
Viene usato per interagire con Firestore (recupero dati profilo).
 */
final userServiceProvider = Provider((ref) => UserService());

final apiServiceProvider = Provider((ref) => ApiService()); //Provider Jolpica API
final f1RepositoryProvider = Provider((ref) => F1Repository(ref.watch(apiServiceProvider))); //Provider REpository.

/*
StreamProvider che ascolta i cambiamenti di stato di Firebase Auth.
Ritorna un oggetto 'User' se loggato, 'null' altrimenti.
*/
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/*
Provider che espone AuthController
Usata nei Form di accedere ai metodi del controller senza creare
nuove istanze ogni volta che il componente viene ricaricato.
 */
final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController();
});

/*
E' il provider che il profilo dell'utente loggato.
Si aggiorna automaticamente quando l'utente entra o esce.
*/
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  // Si mette in ascolta e si aggiorna al cambio stato
  final authState = ref.watch(authStateProvider);
  final userService = ref.watch(userServiceProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        return userService.getUser(user.uid); //Restiuisce i dati utente.
      }
      return Stream.value(null); //Altrimenti rilascia il valore nullo.
    },
    // Qualora ci siano errori restituisce null.
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

final userStreamProvider = StreamProvider.family<UserModel?, String>((ref, uid) {
  return UserService().getUser(uid);
});

// E' il provider che carica il calendario, cosi da usarlo sia nella lista del calendario sia nella homepage.
final calendarProvider = FutureProvider<List<RaceModel>>((ref) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchCalendar();
});

// Questo serve nella homepage per caricare il prossimo evento.
final nextRaceProvider = Provider<RaceModel?>((ref) {
  final calendarAsync = ref.watch(calendarProvider);

  return calendarAsync.when(
    data: (races) {
      final now = DateTime.now();
      try {
        return races.firstWhere((race) => DateTime.parse(race.date).isAfter(now));
      } catch (e) {
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Questo provider carica i piloti.
final driversProvider = FutureProvider<List<DriverModelStanding>>((ref) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchOfficialDriversByTeam();
});

// Questo provider carica i costruttori
final constructorsProvider = FutureProvider<List<ConstructorModel>>((ref) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchTeams();
});

// Caricamento dei risultati della Sprint di un round specifico
final sprintResultsProvider = FutureProvider.family<List<RaceResultModel>, String>((ref, round) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchSprintResult(round);
});

// Usato per ordinare la griglia di partenza.
final sprintGridProvider = Provider.family<AsyncValue<List<RaceResultModel>>, String>((ref, round) {
  final rawAsync = ref.watch(sprintResultsProvider(round));

// Carica i dati della qualifica.
final qualiResultsProvider = FutureProvider.family<List<QualifyingResultModel>, String>((ref, round) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchQualiResult(round);
});

// Caricamento dei risultati di gara.
final raceResultsProvider = FutureProvider.family<List<RaceResultModel>, String>((ref, round) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchRaceResult(round);
});