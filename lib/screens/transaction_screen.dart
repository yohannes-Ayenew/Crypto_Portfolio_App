import 'package:flutter/material.dart';
import '../core/theme.dart';

class TransactionScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const TransactionScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white10
                    : AppTheme.primaryGreen.withOpacity(0.1),
              ),
              child: Icon(icon, size: 80, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 24),
            Text(
              "Process $title",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                "This feature would integrate with a payment gateway or wallet API in a production app.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
