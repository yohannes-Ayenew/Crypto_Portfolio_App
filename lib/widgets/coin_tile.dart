import 'package:flutter/material.dart';
import '../models/crypto_coin.dart';
import '../screens/detail_screen.dart';
import '../core/theme.dart';
import 'package:intl/intl.dart';

class CoinTile extends StatelessWidget {
  final CryptoCoin coin;
  const CoinTile({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.changePercentage >= 0;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.simpleCurrency();

    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailScreen(coin: coin)),
      ),
      leading: Hero(
        tag: coin.symbol,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: isDark ? Colors.transparent : Colors.grey.shade200,
            ),
          ),
          child: ClipOval(
            child: Image.network(coin.imagePath, fit: BoxFit.cover),
          ),
        ),
      ),
      title: Text(
        coin.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      subtitle: Text(coin.symbol, style: const TextStyle(color: Colors.grey)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            currencyFormatter.format(coin.price),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "${isPositive ? '+' : ''}${coin.changePercentage.toStringAsFixed(2)}%",
            style: TextStyle(
              color: isPositive ? AppTheme.primaryGreen : AppTheme.primaryRed,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
