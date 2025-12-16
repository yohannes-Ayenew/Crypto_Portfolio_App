class CryptoCoin {
  final String name;
  final String symbol;
  final double price;
  final double changePercentage;
  final List<double> priceHistory;
  final String imagePath; // The path to the asset

  CryptoCoin({
    required this.name,
    required this.symbol,
    required this.price,
    required this.changePercentage,
    required this.priceHistory,
    required this.imagePath,
  });
}
