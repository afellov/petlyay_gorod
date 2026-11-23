import 'package:flutter/material.dart';
import 'package:walk_city/core/network/pb_client.dart';
import 'package:walk_city/core/widgets/custom_app_bar.dart';
import 'package:walk_city/features/auth/presentation/screens/login_screen.dart';
import 'package:walk_city/features/profile/presentation/screens/profile_avatar_edit_screen.dart';
import 'package:walk_city/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:walk_city/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:walk_city/features/profile/presentation/widgets/profile_avatar_header.dart';
import 'package:walk_city/features/profile/presentation/widgets/profile_stats_card.dart';
import 'package:walk_city/features/qr/presentation/screens/qr_placeholder_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _open(Widget screen) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  Future<void> _logout() async {
    await PbClient.clearAuthSession();
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pb = PbClient.instance;
    final user = pb.authStore.record;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Войдите в аккаунт, чтобы открыть профиль.')),
      );
    }

    final name = user.getStringValue('name');
    final email = user.getStringValue('email');
    final phone = user.getStringValue('phone');
    final username = email.isNotEmpty
        ? email.split('@').first
        : phone.isNotEmpty
        ? phone
        : 'user';
    final avatarName = user.getStringValue('avatar');
    final avatarUrl = avatarName.isEmpty
        ? null
        : pb.files.getUrl(user, avatarName).toString();
    final points = user.getIntValue('points_balance');
    final tasksCompleted = user.getIntValue('tasks_completed');
    final kilometersWalked = user.getDoubleValue('kilometers_walked');
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'ПРОФИЛЬ'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  children: [
                    ProfileAvatarHeader(
                      name: name.isEmpty ? 'Пользователь' : name,
                      username: username,
                      avatarUrl: avatarUrl,
                    ),
                    const SizedBox(height: 18),
                    ProfileActionButtons(
                      onEditPhoto: () => _open(const ProfileAvatarEditScreen()),
                      onEditData: () => _open(ProfileEditScreen(name: name)),
                      onQr: () => _open(const QrPlaceholderScreen()),
                      onSupport: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Контакт службы поддержки ещё не настроен.',
                              ),
                            ),
                          ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Icons.stars_rounded,
                          color: colors.primary,
                        ),
                        title: const Text('Баллы'),
                        trailing: Text(
                          '$points',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProfileStatsCard(
                      tasksCompleted: tasksCompleted,
                      kmPassed: kilometersWalked,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_events_outlined,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Общий рейтинг появится после его запуска.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text('Выйти из аккаунта'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
