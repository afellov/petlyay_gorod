import 'package:flutter/material.dart';
import 'package:walk_city/core/network/pb_client.dart';

import '../widgets/profile_action_buttons.dart';
// Импортируем все наши чистые компоненты:
import '../widgets/profile_avatar_header.dart';
import '../widgets/profile_level_card.dart';
import '../widgets/profile_rating_card.dart';
import '../widgets/profile_stats_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Клиент PocketBase
    final pb = PbClient.instance;

    // Текущий пользователь
    final user = pb.authStore.record;

    // 1. Имя
    final String name = user?.getStringValue('name').isNotEmpty == true
        ? user!.getStringValue('name')
        : "Пользователь";

    // 2 Юзернейм (берем через getStringValue)
    final String email = user?.getStringValue('email') ?? "";
    final String username = email.contains('@')
        ? email.split('@').first
        : "username";

    // 3 Аватарка (безопасный метод getUrl от PocketBase)
    final String? avatarName = user?.getStringValue('avatar');
    final String? avatarUrl =
        (avatarName != null && avatarName.isNotEmpty && user != null)
        ? pb.files.getUrl(user, avatarName).toString()
        : null;

    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          // Фон
          Positioned.fill(child: Container(color: Colors.white)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 10),

                  // 1. Аватар и имя
                  ProfileAvatarHeader(
                    name: name,
                    username: username,
                    avatarUrl: avatarUrl,
                  ),
                  SizedBox(height: 12),

                  // 2 4 кнопки
                  ProfileActionButtons(),
                  SizedBox(height: 20),

                  // 3 Уровень
                  ProfileLevelCard(level: 1, currentXp: 20, maxXp: 100),
                  SizedBox(height: 12),

                  // 4 Статистика
                  ProfileStatsCard(tasksCompleted: 140, kmPassed: 350),
                  SizedBox(height: 24),

                  // 5 Рейтинг
                  ProfileRatingCard(),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
