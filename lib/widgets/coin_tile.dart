import 'package:flutter/material.dart';
import '../models/crypto_coin.dart';
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
      leading: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipOval(
          child: Image.network(
            coin.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.monetization_on, color: Colors.orange),
          ),
        ),
      ),
      title: Text(
        coin.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 17,
        ),
      ),
      subtitle: Text(
        coin.symbol,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
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
          const SizedBox(height: 4),
          Text(
            "${isPositive ? '+' : ''}${coin.changePercentage.toStringAsFixed(2)}%",
            style: TextStyle(
              color: isPositive ? const Color(0xFF00FFA3) : Colors.redAccent,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
