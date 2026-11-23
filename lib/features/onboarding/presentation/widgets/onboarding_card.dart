import 'package:flutter/material.dart';

class OnboardingCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String desc;

  const OnboardingCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 18,
          left: 16,
          right: 15,
        ),
        child: Row(
          children: [
            //! переделать под svg и импортировать другие фотки (.svg)
            Image.asset(iconPath, width: 67, height: 67, fit: BoxFit.contain),

            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Bebas Neue Cyrillic',
                      color: colors.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.01,
                      letterSpacing: 0,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.17,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
