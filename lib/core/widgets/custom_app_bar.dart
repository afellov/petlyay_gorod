import 'package:flutter/material.dart';
import 'package:walk_city/core/theme/app_theme_controller.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showNotifications = false,
    this.showUnreadDot = false,
  });

  final String title;
  final bool showNotifications;
  final bool showUnreadDot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.onSurface;
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: theme.brightness == Brightness.dark
                      ? 'Включить светлую тему'
                      : 'Включить тёмную тему',
                  onPressed: AppThemeController.instance.toggle,
                  icon: Icon(
                    theme.brightness == Brightness.dark
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: foreground,
                    size: 26,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'UNCAGE',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: foreground,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: showNotifications
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none_outlined,
                            color: foreground,
                            size: 28,
                          ),
                          if (showUnreadDot)
                            Positioned(
                              top: 8,
                              right: 5,
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE5367A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
