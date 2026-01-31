import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/coin_tile.dart';
import '../widgets/portfolio_card.dart';
import '../core/theme.dart';
import 'settings_screen.dart';

final searchQueryProvider = StateProvider<String>((ref) => "");
final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crypto Portfolio"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.neonGreen,
        onRefresh: () => ref.refresh(cryptoListProvider.future),
        child: cryptoAsync.when(
          data: (allCoins) {
            var filteredCoins = showFavoritesOnly
                ? allCoins.where((c) => favorites.contains(c.symbol)).toList()
                : allCoins;

            if (searchQuery.isNotEmpty) {
              filteredCoins = filteredCoins
                  .where(
                    (coin) =>
                        coin.name.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ) ||
                        coin.symbol.toLowerCase().contains(
                          searchQuery.toLowerCase(),
                        ),
                  )
                  .toList();
            }

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: PortfolioCard()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      onChanged: (val) =>
                          ref.read(searchQueryProvider.notifier).state = val,
                      decoration: InputDecoration(
                        hintText: "Search coins...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: isDark ? Colors.grey[900] : Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        _navButton(
                          ref,
                          "Market Trends",
                          !showFavoritesOnly,
                          isDark,
                        ),
                        const SizedBox(width: 24),
                        _navButton(ref, "Watchlist", showFavoritesOnly, isDark),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => CoinTile(coin: filteredCoins[index]),
                    childCount: filteredCoins.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, s) => Center(child: Text("Error: $e")),
        ),
      ),
    );
  }

  Widget _navButton(WidgetRef ref, String label, bool isActive, bool isDark) {
    return GestureDetector(
      onTap: () => ref.read(showFavoritesOnlyProvider.notifier).state =
          (label == "Watchlist"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isActive
                  ? (isDark ? Colors.white : Colors.black)
                  : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 24 : 0,
            decoration: BoxDecoration(
              color: AppTheme.neonGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
