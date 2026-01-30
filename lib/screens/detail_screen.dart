import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/crypto_coin.dart';
import '../providers/favorites_provider.dart';
import '../widgets/price_chart.dart';
import '../core/theme.dart';

class DetailScreen extends ConsumerWidget {
  final CryptoCoin coin;
  const DetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPositive = coin.changePercentage >= 0;
    final currencyFormatter = NumberFormat.simpleCurrency();
    final favorites = ref.watch(favoritesProvider);
    final isFavorited = favorites.contains(coin.symbol);

    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(favoritesProvider.notifier)
                .toggleFavorite(coin.symbol),
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                // Logo with Glow Effect (from your screenshot)
                Hero(
                  tag: coin.symbol,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(coin.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  currencyFormatter.format(coin.price),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${isPositive ? '+' : ''}${coin.changePercentage.toStringAsFixed(2)}%",
                  style: TextStyle(
                    color: isPositive
                        ? AppTheme.primaryGreen
                        : AppTheme.primaryRed,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Price Chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PriceChart(
                prices: coin.priceHistory,
                isPositive: isPositive, // Chart color will follow this
              ),
            ),
          ),
          // Buy Button
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Buy Now",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
