import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walk_city/core/theme/app_assets.dart';
import 'package:walk_city/core/theme/app_visuals.dart';

const _pink = Color(0xFFDC3978);

abstract final class MissionArtwork {
  static const cat = 'assets/images/tasks/mission_cat.png';
  static const surf = 'assets/images/tasks/surf_placeholder.svg';
  static const bardak = 'assets/images/tasks/bardak_placeholder.svg';
}

class MissionBanner extends StatelessWidget {
  const MissionBanner({super.key, required this.scale});
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    height: 152 * scale,
    decoration: _decoration(context, 15),
    child: LayoutBuilder(
      builder: (context, bounds) {
        final inset = 12 * scale;
        return Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: bounds.maxWidth * .5,
              child: Image.asset(AppAssets.bannerSplatter, fit: BoxFit.contain),
            ),
            Positioned(
              top: inset,
              left: inset,
              right: inset,
              child: Text(
                'Хотите потратить баллы?',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 18 * scale,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: AppVisuals.of(context).heading,
                ),
              ),
            ),
            Positioned(
              top: 43 * scale,
              left: inset,
              width: (bounds.maxWidth * .47).clamp(0, 190 * scale),
              child: Text(
                'Обменивайте накопленные баллы на бонусы, скидки или подарки.',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12 * scale,
                  height: 1.33,
                  color: AppVisuals.of(context).body,
                ),
              ),
            ),
            Positioned(
              bottom: 10 * scale,
              left: inset,
              child: Container(
                width: 143 * scale,
                height: 28 * scale,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9669B),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Потратить баллы',
                  style: TextStyle(
                    fontFamily: 'Russo One',
                    fontSize: 11 * scale,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10 * scale,
              top: 15 * scale,
              width: 152 * scale,
              height: 127 * scale,
              child: Image.asset(MissionArtwork.cat, fit: BoxFit.contain),
            ),
          ],
        );
      },
    ),
  );
}

class MissionList extends StatelessWidget {
  const MissionList({super.key, required this.scale});
  final double scale;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final mission in _missions) ...[
        MissionCard(mission: mission, scale: scale),
        SizedBox(height: 12 * scale),
      ],
    ],
  );
}

class MissionCard extends StatelessWidget {
  const MissionCard({super.key, required this.mission, required this.scale});
  final MissionPreview mission;
  final double scale;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: 154 * scale,
    padding: EdgeInsets.all(8 * scale),
    decoration: _decoration(context, 10, missionCard: true),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                SvgPicture.asset(mission.asset, fit: BoxFit.cover),
                Positioned(
                  left: 5 * scale,
                  top: 5 * scale,
                  child: _Badge(
                    mission.venue,
                    foreground: Colors.black,
                    scale: scale,
                  ),
                ),
                Positioned(
                  right: 5 * scale,
                  top: 5 * scale,
                  child: _Badge(
                    mission.reward,
                    foreground: AppVisuals.of(context).accentText,
                    scale: scale,
                    background: AppVisuals.of(context).reward,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12 * scale),
        Expanded(
          flex: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mission.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w700,
                  fontSize: 15 * scale,
                  height: 1.06,
                  color: AppVisuals.of(context).heading,
                ),
              ),
              SizedBox(height: 7 * scale),
              Expanded(
                child: Text(
                  mission.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 11.5 * scale,
                    height: 1.34,
                    color: AppVisuals.of(context).body,
                  ),
                ),
              ),
              Container(
                height: 30 * scale,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _pink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Посмотреть на карте',
                    style: TextStyle(
                      fontFamily: 'Russo One',
                      fontSize: 11 * scale,
                      color: Colors.white,
                    ),
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

class _Badge extends StatelessWidget {
  const _Badge(
    this.label, {
    required this.foreground,
    required this.scale,
    this.background = Colors.white,
  });
  final String label;
  final Color foreground, background;
  final double scale;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 2 * scale),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontFamily: 'UNCAGE',
        fontSize: 9 * scale,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
    ),
  );
}

BoxDecoration _decoration(
  BuildContext context,
  double radius, {
  bool missionCard = false,
}) => BoxDecoration(
  color: missionCard
      ? (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1F1A20)
            : Colors.white)
      : AppVisuals.of(context).card,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: [BoxShadow(color: AppVisuals.of(context).shadow, blurRadius: 4)],
);

class MissionPreview {
  const MissionPreview({
    required this.venue,
    required this.reward,
    required this.title,
    required this.description,
    required this.asset,
  });
  final String venue, reward, title, description, asset;
}

const _missions = <MissionPreview>[
  MissionPreview(
    venue: 'SURF COFFEE',
    reward: '+70 Б.',
    title: 'Купите кофе в Surf Coffee',
    description:
        'Купите любое кофе в Surf coffee и получите за это вознаграждение',
    asset: MissionArtwork.surf,
  ),
  MissionPreview(
    venue: 'БАРДАК',
    reward: '+90 Б.',
    title: 'Купите любое блюдо от 300руб.',
    description:
        'Купите любое блюдо в “Бардак” и получите за это вознаграждение',
    asset: MissionArtwork.bardak,
  ),
];
