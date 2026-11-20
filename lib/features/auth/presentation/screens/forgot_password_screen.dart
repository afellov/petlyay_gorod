import 'package:flutter/material.dart';
import 'package:walk_city/core/widgets/app_button.dart';
import 'package:walk_city/features/auth/data/repositories/auth_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите email, связанный с аккаунтом.')),
      );
      return;
    }
    setState(() => _sending = true);
    try {
      await AuthRepository().requestPasswordReset(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Если аккаунт найден, письмо для сброса пароля будет отправлено.',
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Не удалось отправить письмо. Проверьте подключение и настройки почты сервера.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Восстановление доступа')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Укажите email аккаунта. PocketBase отправит письмо со ссылкой для сброса пароля.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: 'Email'),
          onSubmitted: (_) => _send(),
        ),
        const SizedBox(height: 24),
        AppButton(
          height: 60,
          fontSize: 18,
          text: _sending ? 'ОТПРАВЛЯЕМ…' : 'ОТПРАВИТЬ ПИСЬМО',
          onTap: () {
            if (!_sending) _send();
          },
        ),
      ],
    ),
  );
}
