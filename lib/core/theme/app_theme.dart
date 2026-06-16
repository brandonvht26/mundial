import 'package:flutter/material.dart';

class AppTheme {
  // Paleta de colores Mundial 2026
  static const Color torchRed = Color(0xFFE61D25);
  static const Color hermesBlue = Color(0xFF2A398D);
  static const Color averageGreen = Color(0xFF3CAC3B);
  static const Color lightGray = Color(0xFFD1D4D1);
  static const Color darkHeatherGrey = Color(0xFF474A4A);

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'SNPro',
      primaryColor: hermesBlue,
      scaffoldBackgroundColor: darkHeatherGrey,
      colorScheme: const ColorScheme.light(
        primary: hermesBlue,
        secondary: torchRed,
        surface: lightGray,
        error: torchRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: hermesBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: lightGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: torchRed,
      ),
    );
  }
}
