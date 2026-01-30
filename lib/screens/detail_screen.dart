import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/crypto_coin.dart';
import '../providers/favorites_provider.dart';
import '../widgets/price_chart.dart';

class DetailScreen extends ConsumerWidget {
  // Changed to ConsumerWidget
  final CryptoCoin coin;

  const DetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = NumberFormat.simpleCurrency();
    final isPositive = coin.changePercentage >= 0;

    // Watch the favorites list
    final favorites = ref.watch(favoritesProvider);
    final isFavorited = favorites.contains(coin.symbol);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(coin.name),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // --- FAVORITE BUTTON IN APPBAR ---
          IconButton(
            onPressed: () => ref
                .read(favoritesProvider.notifier)
                .toggleFavorite(coin.symbol),
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : Colors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.network(coin.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currencyFormatter.format(coin.price),
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${isPositive ? '+' : ''}${coin.changePercentage.toStringAsFixed(2)}%",
                    style: TextStyle(
                      color: isPositive
                          ? const Color(0xFF00FFA3)
                          : Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Chart Section
            SizedBox(
              height: 250,
              width: double.infinity,
              child: PriceChart(
                prices: coin.priceHistory,
                isPositive: isPositive,
              ),
            ),

            const Spacer(),

            // Buy Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FFA3),
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
          ],
        ),
      ),
    );
  }
}
