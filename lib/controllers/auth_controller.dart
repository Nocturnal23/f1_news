import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  Future<void> signUp({required String displayName, required String email, required String password}) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(user.user!.uid).set({
        'displayName': displayName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

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

  //Funzione per il recupero password.
  Future<void> restorePassword(email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }

  //Funzione per l'accesso come opite
  Future<UserCredential?> signAsGuest() async {
    try {
      return await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print("Errore accesso ospite: $e");
      return null;
    }
  }
}
// Salvare lo username dell'utente.
// Conferma account via mail. OK.
// Recupero password.
// Accedi via google.
// Accesso come ospite. Ok.

/* Nota: Costruire una classe dizionario per contenere gli errori.
Magari costruire un enum dove vengono associati gli errori cosi da usare questa
classe in giro per il codice anzichè inserire a mano le stringhe.
 */
  //Funzione per salvare i dati dell'utente
  Future<void> _saveUserData(
    String displayName,
    String email,
    UserCredential user,
  ) async {
    await _firestore.collection('users').doc(user.user!.uid).set({
      'displayName': displayName,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
