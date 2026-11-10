import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1 Луна (тут в будущем будет переключение темной темы)
        const Icon(Icons.nightlight_round, size: 28),
        
        // 2 Текст, который передается в конструктор
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1),
        ),
        
        // 3 Колокольчик с уведомлением
        Stack(
          children: [
            const Icon(Icons.notifications_none, size: 30),
            Positioned(
              right: 2, top: 2,
              child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.pink, shape: BoxShape.circle)),
            ),
          ],
        ),
      ],
    );
  }
}