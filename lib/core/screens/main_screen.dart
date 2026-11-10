import 'package:flutter/material.dart';
import 'package:walk_city/core/widgets/custom_bottom_nav_bar.dart';
import 'package:walk_city/features/home/presentation/screens/home_screen.dart';
import 'package:walk_city/features/profile/presentation/screens/profile_screen.dart';
import 'package:walk_city/features/tasks/presentation/screens/tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Список страниц. 
  // При переключении индексов в навбаре будет показываться нужная страница
  final List<Widget> _screens = const [
    HomeScreen(),
    TasksScreen(),
    Scaffold(
      body: Center(
        child: Text("Карта (В разработке)", style: TextStyle(fontSize: 20)),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text("Магазин (В разработке)", style: TextStyle(fontSize: 20)),
      ),
    ),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // Разрешает экрану залезть ПОД нижнюю панель
      extendBody: true,

      body: _screens[_currentIndex],

      // навигационная панель
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
