import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/coin_tile.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/shimmer_tile.dart';

// State provider to track the selected tab
final showFavoritesOnlyProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoListProvider);
    final favorites = ref.watch(favoritesProvider);
    final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);

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
            final displayedCoins = showFavoritesOnly
                ? allCoins.where((c) => favorites.contains(c.symbol)).toList()
                : allCoins;

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: PortfolioCard()),

                // --- NEW NAVIGATION SECTION ---
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
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

                // Empty state for Favorites
                if (showFavoritesOnly && displayedCoins.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "Your watchlist is empty",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CoinTile(coin: displayedCoins[index]),
                      childCount: displayedCoins.length,
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
          loading: () => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: PortfolioCard()),
              const SliverToBoxAdapter(
                child: SizedBox(height: 60),
              ), // Space for shimmer nav
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

  // Helper widget for the custom Navigation Tabs
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
          // Animated underline indicator
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
