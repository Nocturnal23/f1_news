import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_models.dart';
import '../services/user_service.dart';

final userStreamProvider = StreamProvider.family<UserModel?, String>((ref, uid) {
  return UserService().getUser(uid);
});