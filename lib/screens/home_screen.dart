import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/coin_tile.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/shimmer_tile.dart';

// 1. Provider to track the search text
final searchQueryProvider = StateProvider<String>((ref) => "");

// 2. Provider to track the selected tab (Market vs Watchlist)
final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoListProvider);
    final favorites = ref.watch(favoritesProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Crypto Portfolio"),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF00FFA3),
        onRefresh: () => ref.refresh(cryptoListProvider.future),
        child: cryptoAsync.when(
          data: (allCoins) {
            // --- FILTERING LOGIC ---
            // First, filter by Watchlist if enabled
            var filteredCoins = showFavoritesOnly
                ? allCoins.where((c) => favorites.contains(c.symbol)).toList()
                : allCoins;

            // Then, filter by Search Query
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

                // --- SEARCH BAR SECTION ---
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) =>
                          ref.read(searchQueryProvider.notifier).state = value,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search coins...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        // Show clear button only if typing
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () =>
                                    ref
                                            .read(searchQueryProvider.notifier)
                                            .state =
                                        "",
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // --- NAVIGATION TABS ---
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        _navButton(
                          ref: ref,
                          label: "Market Trends",
                          isActive: !showFavoritesOnly,
                          onTap: () =>
                              ref
                                      .read(showFavoritesOnlyProvider.notifier)
                                      .state =
                                  false,
                        ),
                        const SizedBox(width: 24),
                        _navButton(
                          ref: ref,
                          label: "Watchlist",
                          isActive: showFavoritesOnly,
                          onTap: () =>
                              ref
                                      .read(showFavoritesOnlyProvider.notifier)
                                      .state =
                                  true,
                        ),
                      ],
                    ),
                  ),
                ),

                // --- EMPTY STATES ---
                if (filteredCoins.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            color: Colors.grey[800],
                            size: 64,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isEmpty
                                ? "Your watchlist is empty"
                                : "No results for '$searchQuery'",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // --- COIN LIST ---
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
          loading: () => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: PortfolioCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ShimmerTile(),
                  childCount: 6,
                ),
              ),
            ],
          ),
          error: (err, stack) => Center(
            child: Text(
              "Error: $err",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navButton({
    required WidgetRef ref,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3,
            width: isActive ? 30 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF00FFA3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
