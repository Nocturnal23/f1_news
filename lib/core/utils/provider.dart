import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/auth_controller.dart';
import '../models/user_models.dart';
import '../services/user_service.dart';

/*
Fornisce un'istanza di UserService a tutta l'app.
Viene usato per interagire con Firestore (recupero dati profilo).
 */
final userServiceProvider = Provider((ref) => UserService());

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
