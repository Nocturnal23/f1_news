import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers/provider.dart';

// Notifier per gestire i preferiti e sincronizzarsi con Firestore.
class FavoritesController extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final userProfileAsync = ref.watch(currentUserProvider);

    return userProfileAsync.when(
      data: (userModel) {
        if (userModel != null && userModel.favorites != null) {
          return Set<String>.from(userModel.favorites);
        }
        return {};
      },
      loading: () => {},
      error: (_, __) => {},
    );
  }

  Future<void> toggleFavorite(String favoriteId) async {
    final user = ref.read(authControllerProvider).currentUser;
    if (user == null) return;

    final userService = ref.read(userServiceProvider);
    final currentFavorites = state;

    if (currentFavorites.contains(favoriteId)) {
      state = { ...currentFavorites }..remove(favoriteId);
      await userService.removeFavorite(user.uid, favoriteId);
    } else {
      state = { ...currentFavorites, favoriteId };
      await userService.addFavorite(user.uid, favoriteId);
    }
  }
}