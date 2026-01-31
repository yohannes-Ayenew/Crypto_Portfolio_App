import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for HapticFeedback
import '../core/theme.dart';
import '../screens/send_screen.dart';
import '../screens/receive_screen.dart';
import '../screens/buy_screen.dart';
import '../screens/swap_screen.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color subTextColor = isDark ? Colors.grey : Colors.grey[700]!;

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
              color: subTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "\$45,230.50",
            style: TextStyle(
              color: textColor,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionIcon(
                context,
                Icons.arrow_upward,
                "Send",
                const SendScreen(),
              ),
              _actionIcon(
                context,
                Icons.arrow_downward,
                "Receive",
                const ReceiveScreen(),
              ),
              _actionIcon(
                context,
                Icons.swap_horiz,
                "Swap",
                const SwapScreen(),
              ),
              _actionIcon(context, Icons.credit_card, "Buy", const BuyScreen()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(
    BuildContext context,
    IconData icon,
    String label,
    Widget destinationScreen,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Provide tactile feedback
        HapticFeedback.lightImpact();

        // Professional Navigation
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Background adapts to theme: tinted green for light, dark glass for dark
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : AppTheme.primaryGreen.withOpacity(0.12),
            ),
            child: Icon(
              icon,
              color: isDark ? AppTheme.neonGreen : AppTheme.primaryGreen,
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.grey : Colors.grey[800],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
