import 'package:flutter/material.dart';

class ProfileAvatarHeader extends StatelessWidget {
  final String name;
  final String username;
  final String? avatarUrl;

  const ProfileAvatarHeader({
    super.key,
    required this.name,
    required this.username,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.outline, width: 2),
            color: colors.surfaceContainerHighest,
            image: avatarUrl != null
                ? DecorationImage(
                    image: NetworkImage(avatarUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: avatarUrl == null
              ? Icon(Icons.person, size: 70, color: colors.onSurfaceVariant)
              : null,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "@$username",
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name.toUpperCase(),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: colors.primary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
