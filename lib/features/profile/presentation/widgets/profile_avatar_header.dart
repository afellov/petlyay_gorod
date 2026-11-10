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
    return Column(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2),
            color: Colors.grey.shade300,
            image: avatarUrl != null
                ? DecorationImage(
                    image: NetworkImage(avatarUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: avatarUrl == null
              ? const Icon(Icons.person, size: 70, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
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
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Color(0xFFE5397F),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
