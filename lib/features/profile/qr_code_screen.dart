import 'package:flutter/material.dart';
import 'package:walk_city/core/theme/palette.dart';
import 'package:walk_city/core/widgets/header.dart';

/// Экран QR-код
class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  /// Когда появится функционал — это поле станет параметром экрана
  static const String _code = '5482';

  @override
  Widget build(BuildContext context) {
    final palette = Palette.of(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: Stack(
        children: [
          // Фоновая текстура профиля
          Positioned.fill(
            child: Image.asset(
              'assets/images/profile/bg_profile.png',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Header(text: 'QR-КОД', palette: palette),

                // Кнопка «назад» отдельной строкой, как в макете.
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: ProfileBackButton(palette: palette),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 2, 16, 16),
                    child: Column(
                      children: [
                        _PartnerBanner(palette: palette),
                        const SizedBox(height: 16),
                        _QrCard(palette: palette, code: _code),
                        const SizedBox(height: 16),
                        _HowToUseCard(palette: palette),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerBanner extends StatelessWidget { /// баннер покажите qr code партнеру
  const _PartnerBanner({required this.palette});

  final Palette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.bannerFill,
            palette.bannerFill.withValues(alpha: 0.45),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.bannerBorder, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QrBadge(palette: palette, size: 46),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Покажите QR-код партнёру,',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: palette.ink,
                  ),
                ),

                // Text.rich — один Text, внутри которого разные стили
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: palette.ink,
                    ),
                    children: [
                      const TextSpan(text: 'чтобы получить '),
                      TextSpan(
                        text: 'скидку',
                        style: TextStyle(color: palette.pink),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  'Если скидку необходимо использовать, партнёр '
                  'может ввести код вручную.',
                  style: TextStyle(
                    fontSize: 9.5,
                    height: 1.35,
                    color: palette.hint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Большая карточка с QR-кодом
class _QrCard extends StatelessWidget {
  const _QrCard({required this.palette, required this.code});

  final Palette palette;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: palette.fieldFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: palette.pink.withValues(alpha: 0.55),
          width: 1.2,
        ),
        // Мягкое розовое свечение вокруг карточки
        boxShadow: [
          BoxShadow(
            color: palette.pink.withValues(alpha: 0.18),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // AspectRatio держит квадрат 1:1 при любой ширине экрана
          // QR-код не должен растягиваться
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/images/profile/qr.png',
                fit: BoxFit.contain,
                //показываем заглушку
                errorBuilder: _qrPlaceholder,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Код: ',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: palette.pink,
                ),
              ),
              Text(
                code,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: palette.pink,
                ),
              ),
              const SizedBox(width: 8),
              // TODO: подтянуть функционал и сделать иконку интерактивной
              Icon(Icons.copy_rounded, size: 14, color: palette.pink),
            ],
          ),
        ],
      ),
    );
  }
}

/// Заглушка вместо QR-картинки, пока её нет в assets
Widget _qrPlaceholder(BuildContext context, Object error, StackTrace? stack) {
  return const FittedBox(
    fit: BoxFit.contain,
    child: Icon(Icons.qr_code_2, size: 200, color: Color(0xFF111111)),
  );
}

/// Карточка "Как использовать"
class _HowToUseCard extends StatelessWidget {
  const _HowToUseCard({required this.palette});

  final Palette palette;

  static const List<String> _steps = [
    '1. Откройте этот экран у партнёра при оформлении покупки.',
    '2. Партнёр сканирует QR-код.',
    '3. Скидка используется автоматически - партнёр может ввести код '
        'вручную.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.cardFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QrBadge(palette: palette, size: 44),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Как использовать?',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: palette.cardText,
                  ),
                ),
                const SizedBox(height: 7),

                for (final step in _steps)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      step,
                      style: TextStyle(
                        fontSize: 9.5,
                        height: 1.35,
                        color: palette.cardText,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _QrBadge extends StatelessWidget {
  const _QrBadge({required this.palette, required this.size});

  final Palette palette;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.1,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              palette.pink,
              palette.pink.withValues(alpha: 0.65),
            ],
          ),
          borderRadius: BorderRadius.circular(size * 0.26),
          boxShadow: [
            BoxShadow(
              color: palette.pink.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.qr_code_2,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}