import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //Funzione per il login.
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Logica di controllo sulla email verificata.
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) { //Utente non verificato.
        await _firebaseAuth.signOut();
        throw Exception("email-not-verified");
      }

    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }

  //Funzione per la registrazione.
  Future<void> signUp({required String displayName, required String email, required String password}) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _saveUserData(displayName, email, user);

      await sendVerificationEmail();
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      rethrow;
    }
  }

  //Funzione pr il logout.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleAuth.signOut();
    } on FirebaseAuthException catch (e) {
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

  //Funzione per accesso via google.
  Future<void> googleSignIn() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          "253313055688-jhtius7u4q5mf1ej0kcvm8nql8rmuiqm.apps.googleusercontent.com",
    );
    final GoogleSignInAccount? googleUser = await _googleAuth.authenticate();
    if (googleUser == null) {
      throw Exception('google-sign-in-aborted-by-user');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(
      credentials,
    );

    if (userCredential.additionalUserInfo?.isNewUser == true) {
      await _saveUserData(
        userCredential.user!.displayName ?? "Utente Google",
        userCredential.user!.email ?? "",
        userCredential,
      );
    }
  }

  //Funzione per salvare i dati dell'utente
  Future<void> _saveUserData(String displayName, String email, UserCredential user) async {
    await _firestore.collection('users').doc(user.user!.uid).set({
      'displayName': displayName,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //Funzione per aggiornare la password.
  Future<void> changePassword(currentPassword, newPassword) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );

      await currentUser?.reauthenticateWithCredential(credential);

      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      print('Failed update password: ${e.code}');
      print(e.message);
      rethrow;
    }
  }

  bool isGoogleUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;

    for (final providerProfile in user.providerData) {
      if (providerProfile.providerId == 'google.com') {
        return true;
      }
    }
    return false;
  }

  // Funzione per eliminare definitivamente l'account
  Future<void> deleteAccount(String currentPassword) async {
    final user = _firebaseAuth.currentUser;
    try {
      AuthCredential credential;
      if (!isGoogleUser()) {
        credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: currentPassword!,
        );
      } else {
        final googleUser = await _googleAuth.authenticate();
        final googleAuth = googleUser.authentication;

        credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
      }
      await user?.reauthenticateWithCredential(credential);
      await _firestore
          .collection('users')
          .doc(user?.uid)
          .delete();

      await user?.delete();

    } on FirebaseAuthException catch (e) {
      print('Failed to delete account: ${e.code}');
      rethrow;
    }
  }
}
