import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String walletAddress = "0x71C7656EC7ab88b098defB751B7401B5f6d8976F";

    return Scaffold(
      appBar: AppBar(title: const Text("Receive Crypto")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Bitcoin Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            // QR Code Placeholder
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.network(
                "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=$walletAddress",
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                walletAddress,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(const ClipboardData(text: walletAddress));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Address copied!")),
                );
              },
              icon: const Icon(Icons.copy, color: AppTheme.primaryGreen),
              label: const Text(
                "Copy Address",
                style: TextStyle(color: AppTheme.primaryGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
