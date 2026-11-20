import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEditPhoto;
  final VoidCallback onEditData;
  final VoidCallback onQr;
  final VoidCallback onSupport;

  const ProfileActionButtons({
    super.key,
    required this.onEditPhoto,
    required this.onEditData,
    required this.onQr,
    required this.onSupport,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _item(
          context,
          Icons.add_a_photo_outlined,
          'Изменить фото',
          onEditPhoto,
        ),
        _item(context, Icons.edit_outlined, 'Изменить данные', onEditData),
        _item(context, Icons.qr_code_2, 'QR-код', onQr),
        _item(context, Icons.chat_bubble_outline, 'Поддержка', onSupport),
      ],
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 78,
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: colors.onSurface),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontSize: 9, height: 1.1),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
