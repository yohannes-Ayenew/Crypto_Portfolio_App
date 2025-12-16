import 'package:flutter/material.dart';
import '../models/crypto_coin.dart';
import '../core/theme.dart';
import '../screens/detail_screen.dart';
import 'package:intl/intl.dart';

class CoinTile extends StatelessWidget {
  final CryptoCoin coin;

  const CoinTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.changePercentage >= 0;
    final currencyFormatter = NumberFormat.simpleCurrency();

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(coin: coin)),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      // --- LOGO SECTION ---
      leading: CircleAvatar(
        backgroundColor: AppTheme.cardColor, // Background color of the circle
        radius: 24, // Optional: Adjust size if needed
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Adds space around the logo
          child: Image.asset(
            coin.imagePath, // Uses the path directly from the model
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback if image is missing: Show first letter
              return Text(
                coin.symbol[0],
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),

      // --------------------
      title: Text(
        coin.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        coin.symbol,
        style: const TextStyle(color: AppTheme.secondaryText),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            currencyFormatter.format(coin.price),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "${isPositive ? '+' : ''}${coin.changePercentage}%",
            style: TextStyle(
              color: isPositive ? AppTheme.primaryGreen : AppTheme.primaryRed,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
