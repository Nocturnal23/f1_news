import 'package:firebase_auth/firebase_auth.dart';

class Authcontroller {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Funzione per il login.
  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  //Funzione per la registrazione.
  Future<void> signUp({required String user, required String email, required String password}) async {
    // A quanto pare su Firebase non si può salvare un utente con username, email e password.
    // Probabilemte dovrò creare l'utente usando email e password e successivamente aggiornare
    // la relativa riga dell'utente associato a quella email aggiungendo il campo password.
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }


  //Funzione pr il logout.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}