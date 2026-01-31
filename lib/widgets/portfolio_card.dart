import 'package:flutter/material.dart';
import '../core/theme.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Balance",
            style: TextStyle(
              color: isDark ? Colors.grey : Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "\$45,230.50",
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionIcon(context, Icons.arrow_upward, "Send"),
              _actionIcon(context, Icons.arrow_downward, "Receive"),
              _actionIcon(context, Icons.swap_horiz, "Swap"),
              _actionIcon(context, Icons.credit_card, "Buy"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(BuildContext context, IconData icon, String label) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Light Green tint for light mode, Dark tint for dark mode
            color: isDark
                ? Colors.white.withOpacity(0.07)
                : AppTheme.primaryGreen.withOpacity(0.12),
          ),
          child: Icon(
            icon,
            color: isDark ? AppTheme.neonGreen : AppTheme.primaryGreen,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey : Colors.grey[800],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
