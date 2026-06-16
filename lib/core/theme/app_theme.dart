import 'package:flutter/material.dart';

class AppTheme {
  // Paleta de colores Mundial 2026
  static const Color torchRed = Color(0xFFE61D25);
  static const Color hermesBlue = Color(0xFF2A398D);
  static const Color averageGreen = Color(0xFF3CAC3B);
  static const Color lightGray = Color(0xFFD1D4D1);
  static const Color darkHeatherGrey = Color(0xFF474A4A);
  
  // Colores extendidos para UI Premium
  static const Color scaffoldBackground = Color(0xFFF5F7FA);
  static const Color surfaceWhite = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'SNPro',
      primaryColor: hermesBlue,
      scaffoldBackgroundColor: scaffoldBackground,
      colorScheme: const ColorScheme.light(
        primary: hermesBlue,
        secondary: torchRed,
        surface: surfaceWhite,
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
      cardTheme: CardThemeData(
        color: surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: lightGray.withValues(alpha: 0.3), width: 1),
        ),
        elevation: 8,
        shadowColor: hermesBlue.withValues(alpha: 0.15),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: torchRed,
      ),
    );
  }

  // Gradiente global para headers o fondos especiales
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [hermesBlue, Color(0xFF1A235A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradiente secundario (rojo) para elementos destacados como marcadores/VS
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [torchRed, Color(0xFFA11018)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradiente terciario (verde) para la tabla de grupos
  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [averageGreen, Color(0xFF227821)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradiente dorado (premium)
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFDF00), Color(0xFFD4AF37), Color(0xFF996515)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
