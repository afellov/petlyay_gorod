import 'package:flutter/material.dart';
import 'package:walk_city/core/theme/app_visuals.dart';

class AppTheme {
  static const brand = Color(0xFFDC3978);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: brand,
          brightness: brightness,
          surface: isDark ? AppVisuals.darkBase : Colors.white,
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
          ? AppVisuals.darkBase
          : const Color(0xFFFFFFFF),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppVisuals.darkBase : Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? const Color(0xFF573648)
            : const Color(0xFFF9E2EC),
        labelStyle: TextStyle(
          color: isDark ? const Color(0xFFF9F2F6) : Colors.black,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppVisuals.accent,
          foregroundColor: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: .55)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppVisuals.darkBase : const Color(0xFF292429),
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
