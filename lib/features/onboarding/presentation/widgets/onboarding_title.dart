import 'package:flutter/material.dart';

class OnboardingTitle extends StatelessWidget {
  final String mainText;
  final String pinkText;
  final bool isCentered;

  OnboardingTitle({
    super.key,
    required String mainText,
    required String pinkText,
    this.isCentered = false,
  }) : mainText = mainText.toUpperCase(),
       pinkText = pinkText.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: 'UNCAGE',
          fontSize: 48,
          height: 0.9,

          fontWeight: FontWeight.w700,
        ),
        children: [
          TextSpan(
            text: mainText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 0.48,
            ),
          ),

          TextSpan(
            text: pinkText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 0.48,
            ),
          ),
        ],
      ),

      textAlign: isCentered ? TextAlign.center : TextAlign.start,
    );
  }
}
