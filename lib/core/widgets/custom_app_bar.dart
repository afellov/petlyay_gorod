import 'package:flutter/material.dart';
import 'package:walk_city/core/theme/app_theme_controller.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: Theme.of(context).brightness == Brightness.dark
              ? 'Включить светлую тему'
              : 'Включить тёмную тему',
          onPressed: AppThemeController.instance.toggle,
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            size: 26,
          ),
        ),

        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontSize: 22, letterSpacing: 1),
        ),

        const SizedBox(width: 48),
      ],
    );
  }
}
