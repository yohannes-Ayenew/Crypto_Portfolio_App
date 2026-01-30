import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[900]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[800]! : Colors.grey[100]!,
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.white),
        title: Container(height: 16, width: 100, color: Colors.white),
        subtitle: Container(height: 12, width: 60, color: Colors.white),
        trailing: Container(height: 16, width: 80, color: Colors.white),
      ),
    );
  }
}
