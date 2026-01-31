import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../core/theme.dart';

class PriceChart extends StatelessWidget {
  final List<double> prices;
  final bool isPositive;

  const PriceChart({super.key, required this.prices, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    // Determine the neon color based on price trend
    final Color chartColor = isPositive
        ? AppTheme.neonGreen
        : AppTheme.primaryRed;

    return LineChart(
      LineChartData(
        // Handles the "Scrubbing" (touch interaction)
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            // In some versions this is 'tooltipBgColor', in others 'getTooltipColor'
            // Using a default style is safest across versions
            tooltipRoundedRadius: 8,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((barSpot) {
                return LineTooltipItem(
                  '\$${barSpot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),

        // Clean layout: No grid lines, no side numbers
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),

        lineBarsData: [
          LineChartBarData(
            // Convert the price list into chart points (Spots)
            spots: prices.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList(),

            isCurved: true, // Smooths the line
            color: chartColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), // Hide circles on points
            // Add the beautiful gradient glow under the line
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  chartColor.withOpacity(0.3),
                  chartColor.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
