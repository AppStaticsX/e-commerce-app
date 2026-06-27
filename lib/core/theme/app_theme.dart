import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A1A1A);
  static const Color accentColor = Color(0xFFFFC107);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF1A1A1A);
  static const Color textDark = Color(0xFFF5F5F5);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFAAAAAA);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceLight,
        onSurface: textLight,
        error: Colors.redAccent,
      ),
      fontFamily: 'MI',
      textTheme: const TextTheme().copyWith(
        displayLarge: const TextStyle(color: textLight, fontWeight: FontWeight.bold),
        displayMedium: const TextStyle(color: textLight, fontWeight: FontWeight.bold),
        displaySmall: const TextStyle(color: textLight, fontWeight: FontWeight.bold),
        headlineMedium: const TextStyle(color: textLight, fontWeight: FontWeight.w600),
        titleLarge: const TextStyle(color: textLight, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: textLight),
        bodyMedium: const TextStyle(color: textSecondaryLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: backgroundLight,
        unselectedItemColor: textSecondaryLight,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      iconTheme: const IconThemeData(color: primaryColor),
      cardTheme: CardThemeData(
        color: backgroundLight,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: backgroundLight,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: backgroundLight,
        secondary: accentColor,
        surface: surfaceDark,
        onSurface: textDark,
        error: Colors.redAccent,
      ),
      fontFamily: 'MI',
      textTheme: const TextTheme().copyWith(
        displayLarge: const TextStyle(color: textDark, fontWeight: FontWeight.bold),
        displayMedium: const TextStyle(color: textDark, fontWeight: FontWeight.bold),
        displaySmall: const TextStyle(color: textDark, fontWeight: FontWeight.bold),
        headlineMedium: const TextStyle(color: textDark, fontWeight: FontWeight.w600),
        titleLarge: const TextStyle(color: textDark, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: textDark),
        bodyMedium: const TextStyle(color: textSecondaryDark),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        iconTheme: IconThemeData(color: backgroundLight),
        titleTextStyle: TextStyle(color: backgroundLight, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: backgroundLight,
        unselectedItemColor: textSecondaryDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundLight,
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      iconTheme: const IconThemeData(color: backgroundLight),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
