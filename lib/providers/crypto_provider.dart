import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crypto_coin.dart';

final cryptoListProvider = FutureProvider<List<CryptoCoin>>((ref) async {
  // CoinGecko API URL for top 10 coins
  const url =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=true';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data.map((coinJson) {
        // Extracting sparkline data for the price history
        List<double> sparklineData = List<double>.from(
          coinJson['sparkline_in_7d']['price'].map((e) => e.toDouble()),
        );

        return CryptoCoin(
          name: coinJson['name'],
          symbol: coinJson['symbol'].toUpperCase(),
          price: coinJson['current_price'].toDouble(),
          changePercentage: coinJson['price_change_percentage_24h'].toDouble(),
          imagePath: coinJson['image'], // This will now be a URL
          priceHistory: sparklineData,
        );
      }).toList();
    } else {
      throw Exception('Failed to load market data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
});
