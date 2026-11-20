import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:walk_city/features/auth/data/repositories/auth_repository.dart';

class ProfileAvatarEditScreen extends StatefulWidget {
  const ProfileAvatarEditScreen({super.key});

  @override
  State<ProfileAvatarEditScreen> createState() =>
      _ProfileAvatarEditScreenState();
}

class _ProfileAvatarEditScreenState extends State<ProfileAvatarEditScreen> {
  File? _image;
  bool _saving = false;

  Future<void> _chooseImage() async {
    final selected = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (selected != null && mounted) {
      setState(() => _image = File(selected.path));
    }
  }

  Future<void> _save() async {
    final image = _image;
    if (image == null) return;
    setState(() => _saving = true);
    try {
      await AuthRepository().uploadAvatar(image);
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось загрузить фото: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Фото профиля')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: _chooseImage,
              child: CircleAvatar(
                radius: 120,
                backgroundColor: colors.surfaceContainerHighest,
                foregroundImage: _image == null ? null : FileImage(_image!),
                child: _image == null
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: 64,
                        color: colors.primary,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Нажмите на фото, чтобы выбрать изображение',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _image == null || _saving ? null : _save,
                child: _saving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
