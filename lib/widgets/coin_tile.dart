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

      // --- FIXED LOGO SECTION ---
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors
              .white, // Adds a white background if the image is transparent
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            coin.imagePath,
            fit: BoxFit.cover, // This "crops" the square into a circle
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  coin.symbol[0],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // -------------------------
      title: Text(
        coin.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
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
