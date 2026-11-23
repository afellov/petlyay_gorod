import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walk_city/features/auth/presentation/screens/login_screen.dart';
import 'package:walk_city/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:walk_city/features/onboarding/presentation/widgets/onboarding_page_first.dart';
import 'package:walk_city/features/onboarding/presentation/widgets/onboarding_page_second.dart';
import 'package:walk_city/features/onboarding/presentation/widgets/onboarding_page_third.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(keepPage: false);

  final List<Widget> _pages = [
    const OnboardingPageFirst(),
    const OnboardingPageSecond(),
    const OnboardingPageThird(),
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // ! 80 % space
          Expanded(
            child: PageView(
              controller: _pageController,

              // при свайпе вызывается эта малышка
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },

              scrollDirection: Axis.horizontal,
              children: _pages,
            ),
          ),

          const SizedBox(height: 10),

          // ! 20 % space
          SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  // рисуем горизонтально точки циклом
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 3),
                      height: 13,

                      // ширина зависит от того какая страница открыта по индексу
                      width: _currentPage == index ? 24 : 13,

                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color.fromRGBO(220, 57, 120, 1)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 20),

                OnboardingButton(
                  text: _currentPage == _pages.length - 1 ? "НАЧАТЬ" : "ДАЛЕЕ",
                  onTap: () async {
                    // страница не последняя то идем дальше
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    } else {
                      final preferences = await SharedPreferences.getInstance();
                      await preferences.setBool('onboarding_completed', true);
                      if (!mounted) return;
                      Navigator.of(this.context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (_) => false,
                      );
                    }
                  },
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); //удаляем контроллер который уже не используется
    super.dispose();
  }
}
