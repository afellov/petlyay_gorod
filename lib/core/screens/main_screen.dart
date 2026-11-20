import 'package:flutter/material.dart';
import 'package:walk_city/core/widgets/custom_bottom_nav_bar.dart';
import 'package:walk_city/features/home/presentation/screens/home_screen.dart';
import 'package:walk_city/features/map/presentation/screens/map_screen.dart';
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
    MapScreen(),
    SizedBox.shrink(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 3) return;
            setState(() => _currentIndex = index);
          },
        ),
      ),
    );
  }
}
