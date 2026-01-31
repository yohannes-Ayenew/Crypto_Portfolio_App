import 'package:flutter/material.dart';
import '../core/theme.dart';

class SwapScreen extends StatelessWidget {
  const SwapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Swap")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _swapCard(
              "From",
              "Ethereum",
              "1.50 ETH",
              "\$3,450.00",
              Colors.blue,
            ),
            const SizedBox(height: 10),
            const CircleAvatar(
              backgroundColor: AppTheme.primaryGreen,
              child: Icon(Icons.swap_vert, color: Colors.black),
            ),
            const SizedBox(height: 10),
            _swapCard("To", "Solana", "35.20 SOL", "\$3,442.10", Colors.purple),
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Exchange Rate", style: TextStyle(color: Colors.grey)),
                Text(
                  "1 ETH = 23.46 SOL",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {},
                child: const Text(
                  "Confirm Swap",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _swapCard(
    String label,
    String coin,
    String amount,
    String val,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: color),
                  const SizedBox(width: 8),
                  Text(coin),
                ],
              ),
            ],
          ),
          Text(val, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
