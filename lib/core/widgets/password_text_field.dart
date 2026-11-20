import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon; // Иконка слева (замочек)

  final TextEditingController? controller;

  const PasswordTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    this.controller,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: colors.outline, width: 1.0),
    );

    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.surface,
        hintText: widget.hint,
        // Добавляем вот эту строчку:
        hintStyle: TextStyle(color: colors.onSurfaceVariant),
        prefixIcon: Icon(widget.prefixIcon, color: colors.onSurfaceVariant),

        contentPadding: const EdgeInsets.symmetric(vertical: 18),

        suffixIcon: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              _isObscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: colors.onSurfaceVariant,
            ),
          ),
        ),

        // Применяем рамку
        border: outlineBorder,
        enabledBorder: outlineBorder,
        focusedBorder: outlineBorder,
      ),
    );
  }
}
