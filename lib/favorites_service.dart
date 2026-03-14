import 'package:flutter/foundation.dart';

class FavoritesService {
  FavoritesService._internal();
  static final FavoritesService instance = FavoritesService._internal();

  final ValueNotifier<Set<int>> favorites = ValueNotifier<Set<int>>(<int>{});

  void toggleFavorite(int productId) {
    final current = favorites.value;
    if (current.contains(productId)) {
      favorites.value = Set.of(current)..remove(productId);
    } else {
      favorites.value = Set.of(current)..add(productId);
    }
  }

  bool isFavorite(int productId) => favorites.value.contains(productId);
}
