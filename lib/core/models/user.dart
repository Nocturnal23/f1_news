import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid; //E' il campo presente in Authentication.
  final String email; //E' il campo presente in Firestore.
  final String displayName; //E' il campo presente in Firestore.
  final DateTime createdAt; //E' il campo presente in Firestore.

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
  });

  /*
  - factory in Dart serve quando bisogna costruire un oggetto prendendo
  dati da servizi esterni.

  - documentId è l'identificativo del documento relativo a un utente di
  Firestore.
   */
  factory UserModel.fromMap(Map<String, dynamic>? data, String documentId) {
    // Gestione di un utente non registrato.
    if (data == null) {
      return UserModel(uid: documentId, email: '', displayName: 'Ospite', createdAt: DateTime.now());
    }

    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}