import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color background = Color(0xFF121212);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color primaryGreen = Color(0xFF00FFA3);
  static const Color primaryRed = Color(0xFFFF5959);
  static const Color secondaryText = Color(0xFF8D8D8D);

  // The Dark Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryGreen,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(color: secondaryText),
      ),
    );
  }
}
