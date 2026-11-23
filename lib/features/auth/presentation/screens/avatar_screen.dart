import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walk_city/core/screens/main_screen.dart';
import 'package:walk_city/features/auth/data/repositories/auth_repository.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _saving = false;

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (!mounted || picked == null) return;
      setState(() => _selectedImage = File(picked.path));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось открыть галерею. Проверьте доступ к фото.')),
      );
    }
  }

  void _continueWithoutAvatar() => _continue();

  void _continue() {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const MainScreen()),
      (_) => false,
    );
  }

  Future<void> _saveAvatar() async {
    final image = _selectedImage;
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сначала выберите фотографию')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await AuthRepository().uploadAvatar(image);
      if (mounted) _continue();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось сохранить фото: $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 760;
    final circleSize = (size.width * .56).clamp(190.0, 250.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: Image.asset('assets/images/auth/bg_avatar.png', fit: BoxFit.fitWidth, alignment: Alignment(0, -.05)),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: Image.asset('assets/images/auth/bg_bottom.png', fit: BoxFit.fitWidth, alignment: Alignment.bottomCenter),
                ),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(28, compact ? 18 : 48, 28, 104),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight - 122),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(children: [
                        Text.rich(
                          const TextSpan(children: [
                            TextSpan(text: 'УСТАНОВИ ', style: TextStyle(color: Colors.black)),
                            TextSpan(text: 'АВАТАР', style: TextStyle(color: Color(0xFFE5367A))),
                          ]),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'UNCAGE', fontSize: size.width < 370 ? 24 : 28, height: 1.15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Выбери изображение, которое будет\nпредставлять тебя в городе',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Arial', fontSize: 14, height: 1.25, color: Color(0xFF383838)),
                        ),
                      ]),
                      SizedBox(height: compact ? 24 : 44),
                      Stack(alignment: Alignment.center, children: [
                        SizedBox(
                          width: circleSize + 14,
                          height: circleSize + 14,
                          child: DottedBorder(
                            options: CircularDottedBorderOptions(
                              color: const Color(0xFFE5367A), strokeWidth: 1.7,
                              dashPattern: const [8, 5], strokeCap: StrokeCap.round,
                            ),
                            child: const SizedBox.expand(),
                          ),
                        ),
                        Material(
                          color: const Color(0xFFF8F8F8),
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: _pickImage,
                            child: SizedBox(
                              width: circleSize,
                              height: circleSize,
                              child: _selectedImage == null
                                  ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      const Icon(Icons.add_a_photo_outlined, color: Color(0xFFE5367A), size: 54),
                                      const SizedBox(height: 8),
                                      const Text('ДОБАВИТЬ ФОТО', style: TextStyle(fontFamily: 'UNCAGE', fontSize: 13, fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 6),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        child: Text('Нажми, чтобы выбрать изображение', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
                                      ),
                                    ])
                                  : Image.file(_selectedImage!, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(height: compact ? 22 : 40),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 70),
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF888888)), borderRadius: BorderRadius.circular(17), color: Colors.white.withValues(alpha: .88)),
                        child: Row(children: [
                          const Icon(Icons.lightbulb_outline, size: 40, color: Color(0xFFE5367A)),
                          const SizedBox(width: 18),
                          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text('СОВЕТ', style: TextStyle(fontFamily: 'UNCAGE', fontSize: 15, fontWeight: FontWeight.w700)),
                            SizedBox(height: 4),
                            Text('Используй фото, по которому тебя легко узнать другим участникам!', style: TextStyle(fontSize: 9, height: 1.25)),
                          ])),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 30,
                right: 30,
                bottom: 24,
                child: Row(children: [
                  Expanded(child: _AvatarButton(label: 'ПРОПУСТИТЬ', background: const Color(0xFFF8D7E4), foreground: const Color(0xFFE5367A), onPressed: _continueWithoutAvatar)),
                  const SizedBox(width: 18),
                  Expanded(child: _AvatarButton(label: _saving ? 'СОХРАНЯЕМ…' : 'СОХРАНИТЬ', background: colors.primary, foreground: Colors.white, onPressed: _saving ? null : _saveAvatar)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarButton extends StatelessWidget {
  const _AvatarButton({required this.label, required this.background, required this.foreground, required this.onPressed});
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: background, foregroundColor: foreground, elevation: 0, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 8)),
      child: FittedBox(fit: BoxFit.scaleDown, child: Text(label, style: const TextStyle(fontFamily: 'Russo One', fontSize: 13, letterSpacing: .4))),
    ),
  );
}
