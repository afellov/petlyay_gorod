import 'package:flutter/material.dart';
import 'package:walk_city/core/theme/app_assets.dart';

class AppVisuals {
  const AppVisuals._(this.dark);
  final bool dark;

  static AppVisuals of(BuildContext context) =>
      AppVisuals._(Theme.of(context).brightness == Brightness.dark);

  static const accent = Color(0xFFDC3978);
  static const darkBase = Color(0xFF1F1A20);
  static const backgroundOpacity = .38;
  // Multiplies the existing dark texture so its base becomes darkBase while
  // retaining the pink artwork.
  static const darkBackgroundTint = Color(0xFF99939A);
  Color get accentText => dark ? const Color(0xFFFF8DB9) : accent;
  Color get page => dark ? darkBase : Colors.white;
  Color get card => dark ? darkBase : Colors.white;
  Color get heading => dark ? const Color(0xFFF9F2F6) : Colors.black;
  Color get body => dark ? const Color(0xFFE2D5DC) : const Color(0xFF4C4C4C);
  Color get muted => dark ? const Color(0xFFC8B7C1) : const Color(0xFF555555);
  Color get pill => dark ? const Color(0xFF573648) : const Color(0xFFF9E2EC);
  Color get reward => dark ? const Color(0xFF664356) : const Color(0xFFF9DCE8);
  Color get shadow => dark
      ? Colors.white.withValues(alpha: .25)
      : Colors.black.withValues(alpha: .25);
  String get background =>
      dark ? AppAssets.backgroundDark : AppAssets.backgroundLight;
}

class AppPageBackground extends StatelessWidget {
  const AppPageBackground({super.key});

  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: IgnorePointer(
      child: Opacity(
        opacity: AppVisuals.backgroundOpacity,
        child: Image.asset(
          AppVisuals.of(context).background,
          fit: BoxFit.cover,
          color: AppVisuals.of(context).dark
              ? AppVisuals.darkBackgroundTint
              : null,
          colorBlendMode: AppVisuals.of(context).dark
              ? BlendMode.multiply
              : null,
        ),
      ),
    ),
  );
}
