import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onTap;
  final Color borderColor;

  const SocialButton({
    super.key,
    required this.iconPath,
    this.onTap,
    this.borderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: enabled ? 'Вход через VK' : 'Вход через VK пока недоступен',
      child: Opacity(
        opacity: enabled ? 1 : 0.38,
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            width: 70,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
