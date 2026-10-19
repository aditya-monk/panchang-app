import 'package:flutter/material.dart';

class AppTheme {
  // Cultural Indian Palette
  static const Color ivoryBackground = Color(0xFFFDFBF7);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color saffronPrimary = Color(0xFFD97706);
  static const Color saffronAccent = Color(0xFFF59E0B);
  static const Color deepMaroon = Color(0xFF881337);
  static const Color sacredGreen = Color(0xFF14532D);
  static const Color deepText = Color(0xFF1C1917);
  static const Color subtleText = Color(0xFF78716C);
  static const Color borderSubtle = Color(0xFFE7E5E4);

  // Status colors
  static const Color suitableGreen = Color(0xFF15803D);
  static const Color conditionalAmber = Color(0xFFB45309);
  static const Color notSuitableRed = Color(0xFFB91C1C);

  static ThemeData lightTheme({bool elderMode = false}) {
    final double textScale = elderMode ? 1.25 : 1.0;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: ivoryBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: saffronPrimary,
        primary: saffronPrimary,
        secondary: deepMaroon,
        surface: cardBackground,
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 1.5,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 0.8),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ivoryBackground,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: deepText),
        titleTextStyle: TextStyle(
          color: deepText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          color: deepText,
          fontSize: 24 * textScale,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: deepText,
          fontSize: 18 * textScale,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: deepText,
          fontSize: 16 * textScale,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: deepText,
          fontSize: 15 * textScale,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          color: subtleText,
          fontSize: 13 * textScale,
          fontWeight: FontWeight.w400,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          final isSelected = states.contains(MaterialState.selected);
          return TextStyle(
            fontSize: (isSelected ? 13.5 : 12.5) * textScale,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? saffronPrimary : deepText,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          final isSelected = states.contains(MaterialState.selected);
          return IconThemeData(
            size: (isSelected ? 26.0 : 24.0) * textScale,
            color: isSelected ? saffronPrimary : deepText,
          );
        }),
      ),
    );
  }
}
