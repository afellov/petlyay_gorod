import 'package:flutter/material.dart';
import 'package:walk_city/features/auth/presentation/widgets/buttons/social_button.dart';

// Импортируй созданный SocialButton

class SocialButtonsRow extends StatelessWidget {
  const SocialButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outline;
    const icons = <String>[
      'assets/images/auth/vk_icon.png',
      'assets/images/auth/vk_icon.png',
      'assets/images/auth/vk_icon.png',
      'assets/images/auth/vk_icon.png',
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Центрируем весь ряд
      // Генерируем список виджетов
      children: List.generate(icons.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ), // Отступы МЕЖДУ кнопками
          child: SocialButton(iconPath: icons[index], borderColor: borderColor),
        );
      }),
    );
  }
}
