import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class PriceChart extends StatelessWidget {
  final List<double> prices;
  final bool isPositive;

  const PriceChart({super.key, required this.prices, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    // Determine min and max Y for scaling
    double minY = prices.reduce((curr, next) => curr < next ? curr : next);
    double maxY = prices.reduce((curr, next) => curr > next ? curr : next);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: prices.length.toDouble() - 1,
        minY: minY * 0.99, // Add some padding below
        maxY: maxY * 1.01, // Add some padding above
        lineBarsData: [
          LineChartBarData(
            spots: prices.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList(),
            isCurved: true,
            color: isPositive ? AppTheme.primaryGreen : AppTheme.primaryRed,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: (isPositive ? AppTheme.primaryGreen : AppTheme.primaryRed)
                  .withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}
