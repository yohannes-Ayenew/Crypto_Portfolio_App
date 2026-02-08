import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<String>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _uid;

  FavoritesNotifier(this._uid) : super([]) {
    _loadFavorites();
  }

  // Load favorites from the Cloud (Firestore)
  Future<void> _loadFavorites() async {
    if (_uid == null) return;

    final doc = await _firestore.collection('users').doc(_uid).get();
    if (doc.exists) {
      final List<dynamic> favs = doc.data()?['watchlist'] ?? [];
      state = favs.cast<String>();
    }
  }

  // Toggle favorite in the Cloud
  Future<void> toggleFavorite(String symbol) async {
    if (_uid == null) return;

    if (state.contains(symbol)) {
      state = state.where((s) => s != symbol).toList();
    } else {
      state = [...state, symbol];
    }

    // Update Firestore
    await _firestore.collection('users').doc(_uid).set({
      'watchlist': state,
    }, SetOptions(merge: true));
  }
}

// We use the User UID from the Auth State to initialize favorites
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
      final user = ref.watch(authStateProvider).value;
      return FavoritesNotifier(user?.uid);
    });
