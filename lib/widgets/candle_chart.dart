import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';

class CryptoCandleChart extends StatelessWidget {
  final List<Candle> candles; // Now accepts real Candle objects

  const CryptoCandleChart({super.key, required this.candles});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Candlesticks(
        candles: candles,
        // The package handles the rest!
      ),
    );
  }
}
