import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = <_NavItemData>[
    _NavItemData('Главная', 'assets/vectors/nav_home.svg'),
    _NavItemData('Задания', 'assets/vectors/nav_tasks.svg'),
    _NavItemData('Карта', 'assets/vectors/nav_map.svg'),
    _NavItemData('Магазин', 'assets/vectors/nav_shop.svg', disabled: true),
    _NavItemData('Профиль', 'assets/vectors/nav_profile.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final islandFill = isDark ? const Color(0xFF1F1A20) : Colors.white;
    final textColor = isDark ? const Color(0xFFF5EDF1) : Colors.black;

    return SafeArea(
      top: false,
      child: Padding(
        // Figma component: 440×122; the 408×64 island sits 16 px in from
        // each side with 5 px above it and 53 px below it (including safe area).
        padding: const EdgeInsets.fromLTRB(16, 5, 16, 19),
        child: SizedBox(
          height: 64,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final slotWidth = (constraints.maxWidth - 12) / _items.length;
              final activeWidth =
                  84 * (constraints.maxWidth / 408).clamp(0.0, 1.0);
              final activeLeft =
                  6 + slotWidth * currentIndex + (slotWidth - activeWidth) / 2;

              return DecoratedBox(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      // Figma shadow: #000000 at 14.5% opacity.
                      color: Color(0x25000000),
                      offset: Offset(0, 1),
                      blurRadius: 9.4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: ColoredBox(
                    color: islandFill,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (currentIndex >= 0 && currentIndex < _items.length)
                          Positioned(
                            left: activeLeft,
                            top: 3,
                            width: activeWidth,
                            height: 58,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.active.withValues(alpha: .2),
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              for (
                                var index = 0;
                                index < _items.length;
                                index++
                              )
                                Expanded(
                                  child: _NavItem(
                                    data: _items[index],
                                    selected: currentIndex == index,
                                    textColor: textColor,
                                    onTap: () => onTap(index),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _NavItemData data;
  final bool selected;
  final Color textColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.selected,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = data.disabled
        ? const Color(0xFFB3B3B3)
        : selected
        ? AppColors.active
        : textColor.withValues(alpha: .7);

    return Semantics(
      button: !data.disabled,
      enabled: !data.disabled,
      selected: selected,
      label: data.label,
      child: GestureDetector(
        onTap: data.disabled ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 26,
                height: 26,
                child: Center(
                  child: SvgPicture.asset(
                    data.asset,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -2),
                child: Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 10,
                    height: 2.2,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final String asset;
  final bool disabled;

  const _NavItemData(this.label, this.asset, {this.disabled = false});
}

abstract final class AppColors {
  static const active = Color(0xFFDC3978);
}
