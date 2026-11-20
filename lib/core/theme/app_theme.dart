import 'package:flutter/material.dart';

class AppTheme {
  static const brand = Color(0xFFDC3978);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: brightness,
      surface: isDark ? const Color(0xFF201A1E) : Colors.white,
    ).copyWith(
      primary: brand,
      onPrimary: Colors.white,
      primaryContainer: isDark
          ? const Color(0xFF54243A)
          : const Color(0xFFFCE4ED),
      onPrimaryContainer: isDark ? const Color(0xFFFFD8E6) : brand,
    );
    final textTheme = ThemeData(brightness: brightness).textTheme
        .apply(
          fontFamily: 'Arial',
          bodyColor: isDark ? const Color(0xFFF5EDF1) : const Color(0xFF171417),
          displayColor: isDark
              ? const Color(0xFFF5EDF1)
              : const Color(0xFF171417),
        )
        .copyWith(
          displayLarge: TextStyle(
            fontFamily: 'UNCAGE',
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'UNCAGE',
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'UNCAGE',
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
          titleLarge: TextStyle(
            fontFamily: 'UNCAGE',
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
          labelLarge: const TextStyle(
            fontFamily: 'Russo One',
            fontWeight: FontWeight.w400,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF171316)
          : const Color(0xFFFFFFFF),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: .55)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF342A30)
            : const Color(0xFF292429),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
