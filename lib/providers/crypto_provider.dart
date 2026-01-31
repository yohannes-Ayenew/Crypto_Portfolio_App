import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candlesticks/candlesticks.dart';
import '../models/crypto_coin.dart';

// 1. PROVIDER FOR MARKET LIST (CoinGecko)
final cryptoListProvider = FutureProvider<List<CryptoCoin>>((ref) async {
  const url =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=true';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) {
      List<double> sparkline = List<double>.from(
        json['sparkline_in_7d']['price'].map((e) => e.toDouble()),
      );
      return CryptoCoin(
        name: json['name'],
        symbol: json['symbol'].toUpperCase(),
        price: json['current_price'].toDouble(),
        changePercentage: json['price_change_percentage_24h'].toDouble(),
        imagePath: json['image'],
        priceHistory: sparkline,
      );
    }).toList();
  } else {
    throw Exception('Failed to load market data');
  }
});

// 2. PROVIDER FOR CANDLESTICKS (Binance)
final candleFetchProvider = FutureProvider.family<List<Candle>, String>((
  ref,
  symbol,
) async {
  final String binanceSymbol = "${symbol}USDT";
  final url =
      'https://api.binance.com/api/v3/klines?symbol=$binanceSymbol&interval=1h&limit=50';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data
        .map(
          (e) => Candle(
            date: DateTime.fromMillisecondsSinceEpoch(e[0]),
            open: double.parse(e[1]),
            high: double.parse(e[2]),
            low: double.parse(e[3]),
            close: double.parse(e[4]),
            volume: double.parse(e[5]),
          ),
        )
        .toList()
        .reversed
        .toList();
  } else {
    throw Exception("Candles not found on Binance for $binanceSymbol");
  }
});
