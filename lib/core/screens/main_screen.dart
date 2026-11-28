import 'package:flutter/material.dart';
import 'package:walk_city/core/widgets/custom_bottom_nav_bar.dart';
import 'package:walk_city/features/home/presentation/screens/home_screen.dart';
import 'package:walk_city/features/map/presentation/screens/map_screen.dart';
import 'package:walk_city/features/profile/presentation/screens/profile_screen.dart';
import 'package:walk_city/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:walk_city/features/events/presentation/screens/events_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _showEvents = false;

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
      canPop: _currentIndex == 0 && !_showEvents,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _showEvents) {
          setState(() => _showEvents = false);
        } else if (!didPop && _currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        // Keep the area around the floating island transparent.
        extendBody: true,
        body: _showEvents
            ? EventsScreen(onBack: () => setState(() => _showEvents = false))
            : IndexedStack(
                index: _currentIndex,
                children: [
                  HomeScreen(
                    onShowAllEvents: () => setState(() => _showEvents = true),
                  ),
                  ..._screens.skip(1),
                ],
              ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 3) return;
            setState(() {
              _currentIndex = index;
              _showEvents = false;
            });
          },
        ),
      ),
    );
  }
}
