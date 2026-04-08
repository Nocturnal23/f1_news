import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Funzione per il login.
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch(e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }

  //Funzione per la registrazione.
  Future<void> signUp({required String user, required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await sendVerificationEmail();

    } on FirebaseAuthException catch(e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }

  //Funzione pr il logout.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch(e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }

  //Gunzione per l'invio della mail di verifica.
  Future<void> sendVerificationEmail() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }

  //Funzione per la verifica della mail.
  Future<bool> isEmailVerified() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return _firebaseAuth.currentUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);

      return false;
    }
  }
}
// Salvare lo username dell'utente.
// Conferma account via mail. OK.
// Recupero password.
// Accedi via google.

/* Nota: Costruire una classe dizionario per contenere gli errori.
Magari costruire un enum dove vengono associati gli errori cosi da usare questa
classe in giro per il codice anzichè inserire a mano le stringhe.
 */