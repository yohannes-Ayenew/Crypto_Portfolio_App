import 'package:flutter/material.dart';
import '../core/theme.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect if we are in Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Dynamic text color: White in Dark Mode, Black in Light Mode
    final Color textColor = isDark ? Colors.white : Colors.black;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // FIXED: Now uses the theme's card color
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        // Added a slight shadow for light mode to make the white card "pop"
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Total Balance",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "\$45,230.50",
            style: TextStyle(
              color: textColor, // Dynamic color
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionIcon(Icons.arrow_upward, "Send", isDark),
              _actionIcon(Icons.arrow_downward, "Receive", isDark),
              _actionIcon(Icons.swap_horiz, "Swap", isDark),
              _actionIcon(Icons.credit_card, "Buy", isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        CircleAvatar(
          // Background of icons slightly darker in light mode
          backgroundColor: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.grey[200],
          child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
