import 'package:flutter/material.dart';
import '../core/theme.dart';

class StylishAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstWord;
  final String secondWord;

  const StylishAppBar({
    super.key,
    required this.firstWord,
    required this.secondWord,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Container(
          height: 60, // "Thin" card look
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              // Shadow on top as requested (using negative offset)
              BoxShadow(
                color: isDark
                    ? const Color.fromARGB(136, 83, 81, 81)
                    : Colors.black12,
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
              // Standard shadow for depth
              BoxShadow(
                color: isDark
                    ? const Color.fromARGB(221, 51, 51, 51)
                    : Colors.black.withOpacity(0.05),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: isDark ? Colors.white : Colors.black,
                ),
                children: [
                  TextSpan(text: "$firstWord "),
                  TextSpan(
                    text: secondWord,
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.neonGreen
                          : AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
