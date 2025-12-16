import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/crypto_coin.dart';
import '../core/theme.dart';
import '../widgets/price_chart.dart';

class DetailScreen extends StatelessWidget {
  final CryptoCoin coin;

  const DetailScreen({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency();
    final isPositive = coin.changePercentage >= 0;

    return Scaffold(
      appBar: AppBar(title: Text(coin.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppTheme.cardColor,
                    child: Text(
                      coin.symbol,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currencyFormatter.format(coin.price),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${isPositive ? '+' : ''}${coin.changePercentage}%",
                    style: TextStyle(
                      color: isPositive
                          ? AppTheme.primaryGreen
                          : AppTheme.primaryRed,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Chart
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
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Buy Now",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
