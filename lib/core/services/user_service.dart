import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserModel?> getUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data(), snapshot.id);
      }
      return null;
    });
  }

  Future<void> addFavorite(String uid, String favoriteId) async {
    await _db.collection('users').doc(uid).update({
      'favorites': FieldValue.arrayUnion([favoriteId]),
    });
  }

  Future<void> removeFavorite(String uid, String favoriteId) async {
    await _db.collection('users').doc(uid).update({
      'favorites': FieldValue.arrayRemove([favoriteId]),
    });
  }
}