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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(coin.name),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  // --- FIXED LARGE LOGO ---
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: ClipOval(
                      child: Image.asset(coin.imagePath, fit: BoxFit.cover),
                    ),
                  ),
                  // ------------------------
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
            SizedBox(
              height: 250,
              width: double.infinity,
              child: PriceChart(
                prices: coin.priceHistory,
                isPositive: isPositive,
              ),
            ),
            const Spacer(),
            SizedBox(
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
          ],
        ),
      ),
    );
  }
}
