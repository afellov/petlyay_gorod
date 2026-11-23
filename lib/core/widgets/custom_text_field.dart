import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final IconData? suffixIcon;

  final TextEditingController? controller; // берет данные из input

  const CustomTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // ЕДИНЫЙ СТИЛЬ РАМКИ: Черный цвет, скругление 15
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: colors.outline, width: 1.0), // Черный цвет!
    );

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.surface,
        hintText: hint,
        // Добавляем вот эту строчку:
        hintStyle: TextStyle(color: colors.onSurfaceVariant),

        prefixIcon: Icon(icon, color: colors.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),

        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: colors.onSurfaceVariant)
            : null,

        // Применяем нашу рамку ко всем состояниям!
        border: outlineBorder,
        enabledBorder: outlineBorder,
        focusedBorder:
            outlineBorder, // Можно сделать розовым при фокусе, если хочешь
      ),
    );
  }
}
