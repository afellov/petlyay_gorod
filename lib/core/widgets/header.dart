import 'package:flutter/material.dart';
import 'package:walk_city/core/theme/palette.dart';

/// "Шапка" - виджет
/// Содержит в себе иконку колокола, луны и заголовок
class Header extends StatelessWidget {
  const Header({required this.palette, required this.text});

  final Palette palette;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        children: [
          // Луна с розовым крестиком (декор из макета).
          SizedBox(
            width: 28,
            height: 28,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.nightlight_round, size: 22, color: palette.ink),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Text(
                    '×',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: palette.pink,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Expanded с центровкой — заголовок ровно по центру экрана,
          // независимо от ширины иконок по краям.
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
                color: palette.ink,
              ),
            ),
          ),

          Icon(Icons.notifications_none_rounded, size: 22, color: palette.ink),
        ],
      ),
    );
  }
}

class ProfileBackButton extends StatelessWidget {
  const ProfileBackButton({super.key, required this.palette});

  final Palette palette;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: Icon(Icons.chevron_left_rounded, size: 26, color: palette.ink),
      ),
    );
  }
}