import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This notifier manages a list of favorite coin symbols (e.g., ['BTC', 'ETH'])
class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  // Load saved favorites from phone memory on startup
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList('favorite_coins') ?? [];
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    if (state.contains(symbol)) {
      state = state.where((s) => s != symbol).toList();
    } else {
      state = [...state, symbol];
    }
    await prefs.setStringList('favorite_coins', state);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
      return FavoritesNotifier();
    });
