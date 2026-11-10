import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildItem(Icons.add_a_photo_outlined, "Изменить фото", () {}),
        _buildItem(Icons.edit_outlined, "Изменить данные", () {}),
        _buildItem(Icons.qr_code_2, "Qr-код", () {}),
        _buildItem(Icons.chat_bubble_outline, "Поддержка", () {}),
      ],
    );
  }

  Widget _buildItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 78,
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, height: 1.1),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
