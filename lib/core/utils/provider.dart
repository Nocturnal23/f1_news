import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../models/constructors_models.dart';
import '../models/drivers_models_standings.dart';
import '../models/races_models.dart';
import '../models/user_models.dart';
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
final calendarProvider = FutureProvider<List<RacesModels>>((ref) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchCalendar();
});

// Questo serve nella homepage per caricare il prossimo evento.
final nextRaceProvider = Provider<RacesModels?>((ref) {
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
final driversProvider = FutureProvider<List<DriverModelStandings>>((ref) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchOfficialDriversByTeam();
});

// Questo provider carica i costruttori
final constructorsProvider = FutureProvider<List<ConstructorModel>>((ref) async {
  final repo = ref.watch(f1RepositoryProvider);
  return await repo.fetchTeams();
});