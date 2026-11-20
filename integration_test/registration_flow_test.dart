import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk_city/core/network/pb_client.dart';
import 'package:walk_city/features/auth/presentation/screens/register_screen.dart';
import 'package:walk_city/features/auth/presentation/screens/avatar_screen.dart';
import 'package:walk_city/features/auth/presentation/screens/login_screen.dart';
import 'package:walk_city/features/auth/presentation/widgets/custom_checkbox.dart';
import 'package:walk_city/features/profile/presentation/screens/profile_screen.dart';
import 'package:walk_city/features/routes/data/repositories/route_repository.dart';
import 'package:walk_city/features/routes/presentation/screens/active_route_screen.dart';
import 'package:walk_city/features/routes/presentation/screens/route_details_screen.dart';
import 'package:walk_city/features/qr/presentation/screens/qr_placeholder_screen.dart';

import 'package:walk_city/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('registration through UI, avatar skip and login reach home', (
    tester,
  ) async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'pb_auth');
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('pb_auth');
    await preferences.setBool('onboarding_completed', false);

    app.main();
    await _waitFor(tester, find.text('ДАЛЕЕ'));
    await binding.takeScreenshot('onboarding');

    await tester.tap(find.text('ДАЛЕЕ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ДАЛЕЕ'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('НАЧАТЬ'));
    await _waitFor(tester, find.byType(LoginScreen));
    expect(find.text('С ВОЗВРАЩЕНИЕМ!'), findsOneWidget);
    await binding.takeScreenshot('login');

    // Password recovery screen remains reachable from the existing login UI.
    final recoveryLink = find.textContaining('Забыли');
    if (recoveryLink.evaluate().isNotEmpty) {
      await tester.tap(recoveryLink.first);
      await _waitFor(tester, find.textContaining('парол'));
      await binding.takeScreenshot('password-recovery');
      await tester.pageBack();
      await _waitFor(tester, find.byType(LoginScreen));
    }

    await tester.tap(find.byKey(const ValueKey('login-sign-up')));
    await _waitFor(tester, find.byType(RegisterScreen));

    final email = 'ui-${DateTime.now().microsecondsSinceEpoch}@example.test';
    final password = 'UiTest-${DateTime.now().microsecondsSinceEpoch}-Aa1!';
    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(4));
    await tester.enterText(fields.at(0), 'UI Test User');
    await tester.enterText(fields.at(1), email);
    await tester.enterText(fields.at(2), password);
    await tester.enterText(fields.at(3), password);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byType(CustomCheckbox));
    await tester.tap(find.byType(CustomCheckbox));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('ЗАРЕГИСТРИРОВАТЬСЯ'));
    await tester.tap(find.text('ЗАРЕГИСТРИРОВАТЬСЯ'));
    await _waitFor(
      tester,
      find.byType(AvatarScreen),
      timeout: const Duration(seconds: 30),
    );
    expect(PbClient.instance.authStore.isValid, isTrue);
    await binding.takeScreenshot('registration-avatar');

    await tester.tap(find.text('Продолжить без фото'));
    await _waitFor(tester, find.text('ЛЕГЕНДА ДНЯ'));
    await binding.takeScreenshot('home-after-registration');

    await tester.tap(find.text('Профиль'));
    await _waitFor(tester, find.byType(ProfileScreen));
    await tester.ensureVisible(find.text('Выйти из аккаунта'));
    await tester.tap(find.text('Выйти из аккаунта'));
    await _waitFor(tester, find.byType(LoginScreen));

    final loginFields = find.byType(TextFormField);
    await tester.enterText(loginFields.at(0), email);
    await tester.enterText(loginFields.at(1), password);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('ВОЙТИ'));
    await tester.tap(find.text('ВОЙТИ'));
    await _waitFor(
      tester,
      find.text('ЛЕГЕНДА ДНЯ'),
      timeout: const Duration(seconds: 30),
    );
    expect(PbClient.instance.authStore.isValid, isTrue);
    expect(await storage.read(key: 'pb_auth'), isNotNull);
    await binding.takeScreenshot('home-after-login');

    // Check the actual bottom navigation and each important destination.
    await tester.tap(find.text('Задания'));
    await _waitFor(tester, find.text('ЗАДАНИЯ'));
    await binding.takeScreenshot('tasks-routes');

    await tester.tap(find.text('Миссии'));
    await tester.pumpAndSettle();
    expect(find.text('Миссии пока не опубликованы.'), findsOneWidget);
    await binding.takeScreenshot('tasks-missions');

    // If development demo data exists, verify route detail and start UI against PB.
    await tester.tap(find.text('Маршруты'));
    await tester.pumpAndSettle();
    final routes = await RouteRepository().getPublishedRoutes();
    String? demoTitleWithCheckpoints;
    for (final route in routes.where((item) => item.title.startsWith('ДЕМО'))) {
      final checkpoints = await RouteRepository().getCheckpoints(route.id);
      if (checkpoints.length > 1 &&
          checkpoints.last.getBoolValue('is_finish')) {
        demoTitleWithCheckpoints = route.title;
        break;
      }
    }
    if (demoTitleWithCheckpoints != null) {
      final demoRoute = find.text(demoTitleWithCheckpoints);
      await tester.ensureVisible(demoRoute);
      await tester.tap(demoRoute);
      await _waitFor(tester, find.text('Начать маршрут'));
      await binding.takeScreenshot('route-detail-demo');
      final route = routes.firstWhere(
        (item) => item.title == demoTitleWithCheckpoints,
      );
      final routeCheckpoints = await RouteRepository().getCheckpoints(route.id);
      final positions = routeCheckpoints
          .map((point) {
            return Position(
              latitude: (point.data['latitude'] as num).toDouble(),
              longitude: (point.data['longitude'] as num).toDouble(),
              timestamp: DateTime.now(),
              accuracy: 5,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              headingAccuracy: 0,
              speed: 0,
              speedAccuracy: 0,
            );
          })
          .toList(growable: false);
      GeolocatorPlatform.instance = _FakeGeolocator(positions: positions);
      await tester.tap(find.text('Начать маршрут'));
      await _waitFor(
        tester,
        find.byType(ActiveRouteScreen),
        timeout: const Duration(seconds: 30),
      );
      final firstCheckpointTitle = routeCheckpoints.first.getStringValue(
        'title',
      );
      await _waitFor(tester, find.text(firstCheckpointTitle));
      await _waitFor(
        tester,
        find.text('Контрольная точка пройдена: $firstCheckpointTitle'),
      );
      final activeCompletions = await PbClient.instance
          .collection('route_completions')
          .getList(
            perPage: 1,
            filter:
                'user = "${PbClient.instance.authStore.record!.id}" && route = "${route.id}" && status = "in_progress"',
            sort: '-created',
          );
      expect(activeCompletions.items, isNotEmpty);
      final visits = await RouteRepository().getCheckpointVisits(
        activeCompletions.items.first.id,
      );
      expect(visits, hasLength(1));
      final finishLabel = find.text('Завершить маршрут');
      await tester.ensureVisible(finishLabel);
      final finishButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Завершить маршрут'),
      );
      expect(finishButton.onPressed, isNull);
      await binding.takeScreenshot('route-active-checkpoints');

      final finishTitle = routeCheckpoints.last.getStringValue('title');
      await _waitFor(
        tester,
        find.text('Контрольная точка пройдена: $finishTitle'),
        timeout: const Duration(seconds: 25),
      );
      final allVisits = await RouteRepository().getCheckpointVisits(
        activeCompletions.items.first.id,
      );
      expect(allVisits, hasLength(routeCheckpoints.length));
      final enabledFinishButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Завершить маршрут'),
      );
      expect(enabledFinishButton.onPressed, isNotNull);

      final userId = PbClient.instance.authStore.record!.id;
      final userBeforeFinish = await PbClient.instance
          .collection('users')
          .getOne(userId);
      final previousBalance = userBeforeFinish.getIntValue('points_balance');
      await tester.tap(find.text('Завершить маршрут'));
      await _waitFor(
        tester,
        find.textContaining('Маршрут завершён! Начислено баллов:'),
      );
      final userAfterFinish = await PbClient.instance
          .collection('users')
          .getOne(userId);
      expect(
        userAfterFinish.getIntValue('points_balance'),
        previousBalance + (route.rewardPoints ?? 0),
      );
      final transactions = await PbClient.instance
          .collection('point_transactions')
          .getList(
            perPage: 10,
            filter: 'completion = "${activeCompletions.items.first.id}"',
          );
      expect(transactions.items, hasLength(1));
      await binding.takeScreenshot('route-completed');
      Navigator.of(tester.element(find.byType(ActiveRouteScreen))).pop();
      await tester.pumpAndSettle();
      Navigator.of(tester.element(find.byType(RouteDetailsScreen))).pop();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Карта'));
    await _waitFor(tester, find.text('КАРТА'));
    await binding.takeScreenshot('map');
    // The shop item must not navigate away or become interactive.
    await tester.tap(find.text('Магазин'));
    await tester.pumpAndSettle();
    expect(find.text('КАРТА'), findsOneWidget);

    await tester.tap(find.text('Профиль'));
    await _waitFor(tester, find.byType(ProfileScreen));
    await binding.takeScreenshot('profile');

    await tester.tap(find.text('QR-код'));
    await _waitFor(tester, find.text('Функция скоро появится'));
    await binding.takeScreenshot('qr-placeholder');
    Navigator.of(tester.element(find.byType(QrPlaceholderScreen))).pop();
    await tester.pumpAndSettle();
    await _waitFor(tester, find.byType(ProfileScreen));

    await tester.tap(find.text('Изменить данные'));
    await _waitFor(tester, find.text('Данные профиля'));
    final profileName = find.byType(TextField).first;
    await tester.enterText(profileName, 'UI Test User Edited');
    await tester.tap(find.text('Сохранить'));
    await _waitFor(tester, find.text('UI Test User Edited'));
    expect(
      PbClient.instance.authStore.record?.getStringValue('name'),
      'UI Test User Edited',
    );

    // Theme can be switched from the app bar and is persisted locally.
    await tester.tap(find.byTooltip('Включить тёмную тему'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(ProfileScreen))).brightness,
      Brightness.dark,
    );
    expect(
      (await SharedPreferences.getInstance()).getString('theme_mode'),
      'dark',
    );
    await binding.takeScreenshot('profile-dark-theme');
    await tester.tap(find.byTooltip('Включить светлую тему'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(ProfileScreen))).brightness,
      Brightness.light,
    );
  });
}

class _FakeGeolocator extends GeolocatorPlatform {
  _FakeGeolocator({required this.positions});

  final List<Position> positions;

  @override
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.whileInUse;

  @override
  Future<LocationPermission> requestPermission() async =>
      LocationPermission.whileInUse;

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) async* {
    for (final position in positions) {
      await Future<void>.delayed(const Duration(seconds: 6));
      yield position;
    }
  }
}

Future<void> _waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final stopwatch = Stopwatch()..start();
  while (stopwatch.elapsed < timeout) {
    await tester.pump(const Duration(milliseconds: 100));
    if (finder.evaluate().isNotEmpty) {
      await tester.pumpAndSettle();
      return;
    }
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 250)),
    );
  }
  fail('Timed out waiting for $finder');
}
