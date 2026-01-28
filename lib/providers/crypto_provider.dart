import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crypto_coin.dart';

final cryptoListProvider = Provider<List<CryptoCoin>>((ref) {
  return [
    CryptoCoin(
      name: "Bitcoin",
      symbol: "BTC",
      price: 43250.00,
      changePercentage: 2.5,
      priceHistory: [41000, 41500, 42000, 41800, 42500, 43250],
      imagePath: 'assets/images/bitcoin-btc-logo.png',
    ),
    CryptoCoin(
      name: "Ethereum",
      symbol: "ETH",
      price: 2250.00,
      changePercentage: -1.2,
      priceHistory: [2300, 2280, 2290, 2260, 2240, 2250],
      imagePath: 'assets/images/ethereum-eth-logo.png',
    ),
    CryptoCoin(
      name: "Solana",
      symbol: "SOL",
      price: 98.50,
      changePercentage: 5.8,
      priceHistory: [88, 90, 92, 91, 95, 98.5],
      imagePath: 'assets/images/solana-sol-logo.png',
    ),
    CryptoCoin(
      name: "Cardano",
      symbol: "ADA",
      price: 0.55,
      changePercentage: 0.8,
      priceHistory: [0.50, 0.52, 0.51, 0.53, 0.54, 0.55],
      imagePath: 'assets/images/cardano-ada-logo.png',
    ),
  ];
});
