import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walk_city/core/theme/app_assets.dart';
import 'package:walk_city/core/theme/app_theme_controller.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showUnreadDot = false,
  });

  final String title;
  final bool showUnreadDot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: ColoredBox(
        color: theme.colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: topInset),
            SizedBox(
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 68),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'UNCAGE',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: foreground,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    child: IconButton(
                      tooltip: isDark
                          ? 'Включить светлую тему'
                          : 'Включить тёмную тему',
                      onPressed: AppThemeController.instance.toggle,
                      icon: SvgPicture.asset(
                        isDark ? AppAssets.sun : AppAssets.moon,
                        width: 27,
                        height: 27,
                        colorFilter: ColorFilter.mode(
                          foreground,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    child: Semantics(
                      label: 'Уведомления',
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                size: 29,
                                color: foreground,
                              ),
                              if (showUnreadDot)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE5367A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const SizedBox(width: 8, height: 8),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
