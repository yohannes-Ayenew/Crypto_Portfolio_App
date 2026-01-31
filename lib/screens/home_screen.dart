import 'package:crypto_app/widgets/stylish_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/coin_tile.dart';
import '../widgets/portfolio_card.dart';
import '../core/theme.dart';

final searchQueryProvider = StateProvider<String>((ref) => "");
final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoListProvider);
    final favorites = ref.watch(favoritesProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const StylishAppBar(firstWord: "CRYPTO", secondWord: "PORTFOLIO"),
      body: RefreshIndicator(
        color: AppTheme.neonGreen,
        onRefresh: () => ref.refresh(cryptoListProvider.future),
        child: cryptoAsync.when(
          data: (allCoins) {
            var filteredCoins = showFavoritesOnly
                ? allCoins.where((c) => favorites.contains(c.symbol)).toList()
                : allCoins;

            if (searchQuery.isNotEmpty) {
              filteredCoins = filteredCoins.where((coin) {
                return coin.name.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    coin.symbol.toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    );
              }).toList();
            }

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: PortfolioCard()),

                // Adaptive Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12,
                    ),
                    child: TextField(
                      onChanged: (value) =>
                          ref.read(searchQueryProvider.notifier).state = value,
                      decoration: InputDecoration(
                        hintText: "Search coins...",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                // Navigation Tabs
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
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

                if (filteredCoins.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text("No results found")),
                  )
                else
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
          error: (err, stack) => Center(child: Text("Error: $err")),
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
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
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
