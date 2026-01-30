import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crypto_provider.dart';
import '../widgets/coin_tile.dart';
import '../widgets/portfolio_card.dart';
import '../widgets/shimmer_tile.dart'; // Import the new shimmer widget

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cryptoAsync = ref.watch(cryptoListProvider);

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
      // RefreshIndicator adds the "Pull to Refresh" functionality
      body: RefreshIndicator(
        color: const Color(0xFF00FFA3),
        backgroundColor: Colors.grey[900],
        onRefresh: () => ref.refresh(cryptoListProvider.future),
        child: cryptoAsync.when(
          data: (cryptoList) => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: PortfolioCard()),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Market Trends",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CoinTile(coin: cryptoList[index]),
                  childCount: cryptoList.length,
                ),
              ),
            ],
          ),
          // LOADING STATE: Now uses 6 ShimmerTiles instead of one spinner
          loading: () => CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: PortfolioCard()),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                sliver: SliverToBoxAdapter(child: SizedBox(height: 20)),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ShimmerTile(),
                  childCount: 6,
                ),
              ),
            ],
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 16),
                Text(
                  "Error: $err",
                  style: const TextStyle(color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () => ref.refresh(cryptoListProvider),
                  child: const Text("Try Again"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
