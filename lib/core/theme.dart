import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFB6403A);
  static const Color secondary = Color(0xFFF4E8E6);
  static const Color accent = Color(0xFFE57368);

  static ThemeData theme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: secondary,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
