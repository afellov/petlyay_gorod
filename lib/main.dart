import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walk_city/core/network/pb_client.dart';
import 'package:walk_city/core/screens/main_screen.dart';
import 'package:walk_city/core/theme/app_theme.dart';
import 'package:walk_city/core/theme/app_theme_controller.dart';
import 'package:walk_city/features/auth/data/repositories/auth_repository.dart';
import 'package:walk_city/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:walk_city/features/auth/presentation/screens/login_screen.dart';
import 'package:walk_city/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // перед началом инициализируй подключение к серверу
  WidgetsFlutterBinding.ensureInitialized();
  await PbClient.init();
  await AppThemeController.instance.load();

  final pb = PbClient.instance;
  if (pb.authStore.isValid) {
    try {
      await pb.collection('users').authRefresh();
    } catch (_) {
      pb.authStore.clear();
    }
  }

  final preferences = await SharedPreferences.getInstance();
  final onboardingCompleted =
      preferences.getBool('onboarding_completed') ?? false;

  runApp(
    BlocProvider(
      create: (context) => AuthBloc(AuthRepository()),
      child: MyApp(onboardingCompleted: onboardingCompleted),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;

  const MyApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppThemeController.instance,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: AppThemeController.instance.mode,
        home: !onboardingCompleted
            ? const OnboardingScreen()
            : PbClient.instance.authStore.isValid
            ? const MainScreen()
            : const LoginScreen(),
      ),
    );
  }
}
