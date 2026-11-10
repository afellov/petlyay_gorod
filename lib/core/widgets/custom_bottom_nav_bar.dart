import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Оборачиваем в SafeArea и Padding, чтобы навбар парил над низом экрана!
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        child: Container(
          height: 70, // Сделали аккуратную компактную высоту
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40), // Овальная пилюля
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1.5,
            ), // Серая рамочка
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 4), // Мягкая тень вниз
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildItem(0, Icons.home_outlined, Icons.home_filled, "Главная"),
              _buildItem(
                1,
                Icons.menu_book_outlined,
                Icons.menu_book,
                "Задания",
              ), // Иконка книжки как на макете
              _buildItem(2, Icons.map_outlined, Icons.map, "Карта"),
              _buildItem(
                3,
                Icons.shopping_bag_outlined,
                Icons.shopping_bag,
                "Магазин",
              ),
              _buildItem(4, Icons.person_outline, Icons.person, "Профиль"),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final bool isActive = currentIndex == index;
    const Color activePink = Color(0xFFFCE4EC); // Наш нежно-розовый

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: isActive 
            ? const Duration(milliseconds: 350) 
            : Duration.zero,
        
        // 1. Упругая кривая - дает эффект надувания пузыря:
        curve: Curves.easeOutBack, 

        // 2. Раздуваем размеры: неактивная маленькая, активная вырастает во все стороны
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 4,
          vertical: isActive ? 6 : 2,
        ),
        
        decoration: BoxDecoration(
          // 3. СЕКРЕТ: анимируем из прозрачного РОЗОВОГО, а не из черного!
          color: isActive 
              ? activePink 
              : activePink.withValues(alpha: 0.0),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? filledIcon : outlineIcon,
              color: isActive ? const Color(0xFFE5397F) : Colors.black87,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                color: isActive ? const Color(0xFFE5397F) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }}