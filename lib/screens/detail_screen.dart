import 'package:crypto_app/providers/crypto_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/crypto_coin.dart';
import '../providers/favorites_provider.dart';
import '../widgets/price_chart.dart';
import '../widgets/candle_chart.dart'; // Import the new candle chart
import '../core/theme.dart';

// State to track which chart is selected
final chartTypeProvider = StateProvider<bool>(
  (ref) => true,
); // true = Line, false = Candle

class DetailScreen extends ConsumerWidget {
  final CryptoCoin coin;
  const DetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPositive = coin.changePercentage >= 0;
    final isLineChart = ref.watch(chartTypeProvider);
    final currencyFormatter = NumberFormat.simpleCurrency();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Fetch real candles from Binance
    final candleAsync = ref.watch(candleFetchProvider(coin.symbol));

    return Scaffold(
      appBar: AppBar(
        title: Text(coin.name),
        actions: [
          IconButton(
            onPressed: () => ref
                .read(favoritesProvider.notifier)
                .toggleFavorite(coin.symbol),
            icon: Icon(
              ref.watch(favoritesProvider).contains(coin.symbol)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: ref.watch(favoritesProvider).contains(coin.symbol)
                  ? Colors.red
                  : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Price Info Header
          Center(
            child: Column(
              children: [
                Hero(
                  tag: coin.symbol,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.network(coin.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  currencyFormatter.format(coin.price),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${isPositive ? '+' : ''}${coin.changePercentage.toStringAsFixed(2)}%",
                  style: TextStyle(
                    color: isPositive
                        ? AppTheme.neonGreen
                        : AppTheme.primaryRed,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // --- CHART TYPE SWITCHER ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _toggleButton(ref, "Line", isLineChart),
                const SizedBox(width: 10),
                _toggleButton(ref, "Candle", !isLineChart),
              ],
            ),
          ),

          // --- DYNAMIC CHART AREA ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: isLineChart
                  ? PriceChart(
                      prices: coin.priceHistory,
                      isPositive: isPositive,
                    )
                  : candleAsync.when(
                      data: (realCandles) =>
                          CryptoCandleChart(candles: realCandles),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(
                        child: Text(
                          "Candles not available for ${coin.symbol}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
            ),
          ),

          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statItem(
                  "Low",
                  "\$${(coin.price * 0.98).toStringAsFixed(2)}",
                  isDark,
                ),
                _statItem(
                  "High",
                  "\$${(coin.price * 1.02).toStringAsFixed(2)}",
                  isDark,
                ),
                _statItem("Vol", "2.4B", isDark),
              ],
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
                  backgroundColor: AppTheme.neonGreen,
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

  Widget _toggleButton(WidgetRef ref, String label, bool isActive) {
    return GestureDetector(
      onTap: () =>
          ref.read(chartTypeProvider.notifier).state = (label == "Line"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.neonGreen : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
