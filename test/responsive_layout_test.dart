import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:walk_city/core/widgets/custom_bottom_nav_bar.dart';
import 'package:walk_city/features/home/presentation/screens/home_screen.dart';
import 'package:walk_city/features/tasks/presentation/screens/tasks_screen.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(375, 812),
    const Size(440, 956),
  ]) {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      testWidgets('home and tasks fit $size $brightness', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final theme = ThemeData(brightness: brightness);
        await tester.pumpWidget(
          MaterialApp(theme: theme, home: const HomeScreen()),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(
          MaterialApp(theme: theme, home: const TasksScreen()),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Миссии'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              bottomNavigationBar: CustomBottomNavBar(
                currentIndex: 1,
                onTap: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
