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
    } on FirebaseAuthException catch(e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }

  }


  //Funzione pr il logout.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}